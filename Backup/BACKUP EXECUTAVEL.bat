REM - comando para configurar qual é o dia da semana, na hora de compactar o backup
echo off
SETLOCAL
SET a count=0
FOR F skip=1 %%D IN ('wmic path win32_localtime get dayofweek') DO (
    set dow=%%D
    IF %%D==0 set dowday=Dom
    IF %%D==1 set dowday=Seg
    IF %%D==2 set dowday=Ter
    IF %%D==3 set dowday=Qua
    IF %%D==4 set dowday=Qui
    IF %%D==5 set dowday=Sex
    IF %%D==6 set dowday=Sab
    SET a count+=1
    goto next
)
next
echo %dowday%

REM - VARIAVEIS
REM - VARIAVEL BACKUP, será o diretório temporário, para copiar os arquivos, sendo assim, não corre o perigo de deletar, os originais.
REM - ZIP, pasta dentro do diretório de backup, para armazenar os arquivos compactados.
REM - DESTINO, diretório para onde você deseja enviar o backup para armazenamento.
REM - DEIXEI EXEMPLIFICADO, como seria os caminhos, note que no destino, selecionei o disco local D:, este script é para backup de segurança em outra midia !!!

set BACKUP=C:\Backup\TEMP
set ZIPS=C:\Backup\Zip
set DESTINO=D:\Backup
set LOG=C:\Backup\Log

REM - ESTRUTURA
echo # - - - - - - - - - - - - - - - - - - - - - - - - - #
echo #         COPIA DE ARQUIVOS EOU DIRETORIOS         #
echo # - - - - - - - - - - - - - - - - - - - - - - - - - #
REM E - Copia diretórios e subdiretórios, inclusive os vazios.
REM S - esta opção para copiar diretórios, subdiretórios e os arquivos contidos neles, além dos arquivos da raiz da fonte . Pastas vazias não será recriada.
REM Y - Suprime o prompt para você confirmar se deseja substituir um arquivo de destino existente.
REM C - Continua copiando, mesmo que ocorram erros.
REM H - Copia arquivos ocultos e do sistema também.
REM Q - Uma espécie de oposto do  f opção, o  q interruptor vai colocar xcopy em modo silencioso, ignorando a exibição na tela de cada arquivo a ser copiado.

cd
REM - ACESSAR pasta onde se localiza o script, dll's, temporários e logs.
cd C:\Backup


REM - Comando para copiar arquivos originais, para a pasta temporária, você pode repetir, e adicionar quantos caminhos achar interessante.
REM - Quando o local tem nome com espaço no meio, adicione aspas duplas " para que o script consiga ler o caminho corretamente.
xcopy "C:\Users\renan\Área de Trabalho"*.* %BACKUP% /e/y/d

REM - Comando para compactar os arquivos, utilizando o 7Zip
7z a -tzip BACKUP%dowday%.zip %BACKUP%

REM - Comando para copiar arquivo compactado, para o diretório destino, onde será feito  backup
xcopy BACKUP%dowday%.zip %DESTINO% /y/d

REM - Comando para mover arquivo compactado, que fica no diretório do script, para pasta de compactados
move BACKUP%dowday%.zip %ZIPS% 

echo # - - - - - - - - - - - - - - - - - - - - - - - - - #
echo # GERANDO LOG DE ARQUIVOS EOU DIRETORIOS COPIADOS  #
echo # - - - - - - - - - - - - - - - - - - - - - - - - - #
REM - comando para criar log, referente ao processo todo
dir s %DESTINO%  %LOG%Arquivos.txt

REM - Comando final, para limpar arquivos temporários, assim não irá sobrecarregar seu espaço !!!
del %backup% 

pause
