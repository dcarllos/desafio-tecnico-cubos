FROM postgres:15.8

# Executado automaticamente no primeiro start (quando o volume estiver vazio)
COPY init.sql /docker-entrypoint-initdb.d/init.sql
