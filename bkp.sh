#!/usr/bin/env bash
set -eu

exec python3 - "$@" <<'PYTHON'
import argparse
import hashlib
import os
from pathlib import Path
import re
import shutil
import stat
import sys
import tempfile
from datetime import datetime, timezone
import xml.etree.ElementTree as ET


def deployment_files(config):
    root = ET.parse(config).getroot()
    namespace = root.tag[:-len("domain")] if root.tag.endswith("}domain") else ""
    if root.tag != namespace + "domain":
        raise ValueError("a configuração não é de um domínio JBoss")

    deployments = {}
    for deployment in root.findall("./{0}deployments/{0}deployment".format(namespace)):
        name = deployment.get("name", "")
        if not name.lower().endswith((".ear", ".war")):
            continue

        contents = deployment.findall(namespace + "content")
        if not contents:
            print("Ignorado (sem conteúdo gerenciado): {!r}".format(name), file=sys.stderr)
            continue

        if "/" in name or "\\" in name or ":" in name or any(
            ord(char) < 32 for char in name
        ):
            raise ValueError("nome de deployment inválido: {!r}".format(name))
        if name in deployments:
            raise ValueError("deployment duplicado: {!r}".format(name))

        digest = contents[0].get("sha1", "")
        if len(contents) != 1 or not re.fullmatch(r"[0-9a-fA-F]{40}", digest):
            raise ValueError("conteúdo gerenciado inválido: {!r}".format(name))
        deployments[name] = digest.lower()

    if not deployments:
        raise ValueError("nenhum EAR ou WAR gerenciado encontrado")
    return deployments


def copy_verified(source, destination, expected_digest):
    if not stat.S_ISREG(source.stat().st_mode):
        raise ValueError("esperado um pacote EAR/WAR em arquivo: {}".format(source))

    digest = hashlib.sha1()
    with source.open("rb") as original, destination.open("xb") as backup:
        for block in iter(lambda: original.read(1024 * 1024), b""):
            backup.write(block)
            digest.update(block)
    if digest.hexdigest() != expected_digest:
        raise ValueError("SHA-1 divergente para {!r}".format(destination.name))


def main():
    parser = argparse.ArgumentParser(
        description="Copia EARs e WARs gerenciados do JBoss em modo domain."
    )
    parser.add_argument("--jboss-home", type=Path, default=os.getenv("JBOSS_HOME") or "/opt/jboss")
    parser.add_argument("--domain-config", type=Path, help="caminho do domain.xml")
    parser.add_argument("--content-dir", type=Path, help="repositório de conteúdo do domínio")
    parser.add_argument("--backup-dir", type=Path, default=os.getenv("BACKUP_DIR") or None)
    args = parser.parse_args()
    domain = args.jboss_home / "domain"
    config = args.domain_config or domain / "configuration" / "domain.xml"
    content = args.content_dir or domain / "data" / "content"
    backup = args.backup_dir or args.jboss_home / "backup"

    try:
        deployments = deployment_files(config)
        os.umask(0o077)
        backup.mkdir(parents=True, exist_ok=True)
        stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
        prefix = "backup-" + stamp + "-"
        with tempfile.TemporaryDirectory(prefix="." + prefix, dir=str(backup)) as staging:
            # Keep the temporary directory itself so its context manager can remove it.
            snapshot = Path(staging) / "packages"
            snapshot.mkdir()
            for name, digest in deployments.items():
                source = content / digest[:2] / digest[2:] / "content"
                copy_verified(source, snapshot / name, digest)
            published = backup / Path(staging).name[1:]
            snapshot.rename(published)
    except (OSError, ET.ParseError, ValueError) as error:
        print("Erro no backup: {}".format(error), file=sys.stderr)
        return 1

    print("{} pacote(s) copiado(s) para {}".format(len(deployments), published))
    return 0


sys.exit(main())
PYTHON
