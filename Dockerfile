FROM mcr.microsoft.com/mssql/server:2019-latest
RUN mkdir -p "/var/opt/mssql/data/backup"
COPY "/var/opt/mssql/data/desafiosoft.bak" "/users/diegooliveira/desktop/desafio"
COPY "/users/diegooliveira/desktop/desafio/RestoreBackup.sql" "/var/opt/mssql/data/backup/RestoreBackup.sql"
RUN /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $env:sa_password -i "/var/opt/mssql/data/backup/RestoreBackup.sql"
RUN rm "/var/opt/mssql/data/backup/desafiosoft.bak"
RUN rm "/var/opt/mssql/data/backup/RestoreBackup.sql"


FROM mcr.microsoft.com/mssql/server:2019-latest
 
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=reallyStrongPwd#123
ENV MSSQL_PID=Developer
ENV MSSQL_TCP_PORT=1433 
        
WORKDIR /data
       
RUN (/var/opt/mssql/data --accept-eula & ) | grep -q "Realizando cópia" &&  /opt/mssql-tools/bin/sqlcmd -Slocalhost -Usa -PreallyStrongPwd#123  -Q"RESTORE DATABASE DESAFIO FROM  DISK = N'/var/opt/mssql/data/desafio.bak' WITH  REPLACE, MOVE N'DESAFIO'     TO N'/var/opt/mssql/data/desafio.mdf',  MOVE N'DESAFIO_log' TO N'/var/opt/mssql/data/desafio_log.ldf';"