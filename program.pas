program creare_puzzle_v2;
{ To Do :
    - git integration #
    - command line option #

    - poz_4 #
    - poz_5 #
    - poz_6
    - poz_7
    - poz_8

    - undo_4 #
    - undo_5 #
    - undo_6
    - undo_7
    - undo_8

    - test poz_4/5/.. si undo_4/5/..

    - poz_final
    - undo_final
    
    - test poz_final si undo_final

    - start

    - citire cuvinte din fisier
    
    - countere (ramane de stabilit)

    - check_it_can_be_done ( verificam daca cel mai lung cuvant <= nr_n )

    - interactiv mode 

    }
const max_n = 100; { dimensiunea maxima a matrici  }
      max_m = 100; { numarul maxim de cuvinte  }
type vector_bool = array[1..255] of boolean;
     matrice_c = array[1..max_n, 1..max_n] of char;

     cuvant = record
        st :string;
        len, poz_l, poz_c, dir :integer;
        vec_poz :vector_bool;
        end;

      vector_cuv = array[1..max_m] of cuvant;

var vec_c :vector_cuv;
    mat :matrice_c;
    nr_dir, nr_cuv, nr_n :integer;
    rez :boolean;

{ ====================================================== }
{ procedures related to data structure <cuvant> }

{ initializam cuvantul  }
procedure init_cuv(var c :cuvant; s :string);
begin
with c do
    begin
    st := s; { atribuim stringul }
    len := length(s); { lungimea lui  }
    poz_l := 0; { pozitia de start  }
    poz_c := 0; { pozitia de finish }
    dir := 0; { directia }

    fillbyte(vec_poz, sizeof(vec_poz), 0); { initializam vectorul cu FALSE }
    end;
end;


{ stergem cuvantul din matrice stiind ca a fost scris spre dreapta  }
procedure undo_cuv_1(var c :cuvant);
{ stergem cuvantul stiind ca e scris spre dreapta  }
var i :integer;
begin
with c do
    begin
    for i := 1 to len do
        if vec_poz[i] then { daca litera de pe pozitia <i> a fost pusa  }
            mat[poz_l, poz_c + i - 1] := '-'; { eliminam din matrice litera }
    end;
{ reinitializam cuvantul  }
init_cuv(c, c.st);
end;


{ stergem cuvantul din matrice stiind ca a fost scris spre dreapta jos, diagonala principala spre dreapta  }
procedure undo_cuv_2(var c :cuvant);
{ stergem cuvantul stiind ca e scris spre dreapta  }
var i :integer;
begin
with c do
    begin
    for i := 1 to len do
        if vec_poz[i] then { daca litera de pe pozitia <i> a fost pusa  }
            mat[poz_l + i - 1, poz_c + i - 1] := '-'; { eliminam din matrice litera }
    end;
{ reinitializam cuvantul  }
init_cuv(c, c.st);
end;


{ stergem cuvantul din matrice stiind ca a fost scris in jos }
procedure undo_cuv_3(var c :cuvant);
{ stergem cuvantul stiind ca e scris spre dreapta  }
var i :integer;
begin
with c do
    begin
    for i := 1 to len do
        if vec_poz[i] then { daca litera de pe pozitia <i> a fost pusa  }
            mat[poz_l + i -1, poz_c] := '-'; { eliminam din matrice litera }
    end;
{ reinitializam cuvantul  }
init_cuv(c, c.st);
end;

{ stergem cuvantul din matrice stiind ca a fost scris pe diagonala secundara in spre stanga }
procedure undo_cuv_4(var c :cuvant);
var i :integer;
begin
with c do
    begin
    for i := 1 to len do
        if vec_poz[i] then { daca litera a fost pozitionata intr-un loc gol }
            mat[poz_l+i-1, poz_c-i+1] := '-'; { eliminam litera din matrice }
    end;
end;

{ stergem cuvantul din matrice stiind ca a fost scris spre stanga }
procedure undo_cuv_5(var c :cuvant);
var i :integer;
begin
with c do
    begin
    for i := 1 to len do
        if vec_poz[i] then { daca caracterul a fost pozitionat intr-un loc gol }
            mat[poz_l, poz_c-i+1] := '-'; { eliminam litera }
    end;
end;

{ afisam informatii despre cuvant  }
procedure afis_cuv(var c :cuvant);
var i :integer;
begin
with c do
    begin
    writeln('st = ', st);
    writeln('poz_lin = ', poz_l);
    writeln('poz_col= ', poz_c);
    writeln('len = ', len);
    writeln('DIr =', dir);
    for i := 1 to len do
        write(vec_poz[i], ' ');
    writeln;
    end;
end;

{}
{ ====================================================== }
{ pozitionam un cuvant }

{ pozitionam spre dreapta pornind din pozitia <i>, <j>  }
function poz_cuv_1(lin, col :integer;var c :cuvant):boolean;
var i :integer;
begin
poz_cuv_1 := true; { consideram ca il putem pozitiona }

{ cuvantul stie din ce pozitie incepe, si in ce directie se indreapta  }
c.poz_l := lin;
c.poz_c := col;
c.dir := 1;

with c do
    begin
    if (col + len - 1) <= nr_n then { avem loc spre dreapta  }
        begin
        for i := 1 to len do { parcurgem fiecare litera }
            if mat[lin, col + i -1] = '-' then { daca locul e gol }
                begin
                vec_poz[i] := true; { marcam litera ca pusa intr-un loc gol }
                mat[lin, col + i - 1] := st[i];
                end
            else { exista deja o litera pe aceasta pozitie }
                if mat[lin, col +i -1] <> st[i] then { daca litera din matrice nu corespunde cu cea a cuvantuli }
                    begin
                    poz_cuv_1 := false; { nu putem pozitiona cuvantul }
                    break; { iesim din loop }
                    end;
        end
    else { nu avem loc spre dreapta }
        poz_cuv_1 := false;
    end;
end;

{ pozitionam sprea dreapa jos, diagonala principala spre dreapta din pozitia <i>, <j> }
function poz_cuv_2(lin, col :integer;var c :cuvant):boolean;
var i :integer;
begin
poz_cuv_2 := true; { consideram ca il putem pozitiona }

{ cuvantul stie din ce pozitie incepe, si in ce directie se indreapta  }
c.poz_l := lin;
c.poz_c := col;
c.dir := 2;

with c do
    begin
    if ((col + len - 1) <= nr_n) AND ((lin+len-1) <= nr_n) then { avem loc spre dreapta }
        begin
        for i := 1 to len do { parcurgem fiecare litera }
            begin
            if mat[lin+i-1, col+i-1] =  '-' then { daca locul e liber }
                begin
                vec_poz[i] := true; { marcam litera ca pusa intr-un loc gol }
                mat[lin+i-1, col+i-1] := st[i];
                end
            else { locul nu e lober }
                if mat[lin+i-1, col+i-1] <> st[i]  then { daca litera nu coincide cu a cuvantului }
                    begin
                    poz_cuv_2 := false; { nu putem pozitiona }
                    break; { iesim din loop }
                    end;
            end;
        end
    else { nu avem loc  }
        poz_cuv_2 := false;
    end;
end;

{ pozitionam in jos cuvantul }
function poz_cuv_3(lin, col :integer;var c :cuvant):boolean;
var i :integer;
begin
poz_cuv_3 := true; { consideram ca il putem pozitiona }

{ atribuim meta-data }
c.poz_l := lin;
c.poz_c := col;
c.dir:= 3;

with c do
    begin
    if (lin+len-1) <= nr_n then { avem loc  }
        begin
        for i := 1 to len do { mergem pe cuvinte  }
            if mat[lin+i-1, col] = '-' then { locul este gol }
                begin
                vec_poz[i] := true; { marcam litera ca adaugata }
                mat[lin+i-1, col] := st[i]; { adaugam caracterul }
                end
            else { exista deja o litera }
                if mat[lin+i-1, col] <> st[i] then { daca litera din matrice nu coincide }
                    begin
                    poz_cuv_3 := false; { nu putem pozitiona }
                    break; { iesim din loop }
                    end;
        end
    else { nu avem loc }
        poz_cuv_3 := false;
    end;
end;

{ pozitionam cuvantul in stanga jos, diagonala secundara spre stanga }
function poz_cuv_4(lin, col :integer; var c :cuvant):boolean;
var i :integer;
begin
poz_cuv_4 := true; { consideram ca il putem pozitiona }

{ atribuim meta-data }
c.poz_l := lin;
c.poz_c := col;
c.dir:= 4;

with c do
    begin
    if ((col-len+1) >= 1) AND ((lin+len-1) <= nr_n) then { avem loc spre stanga }
        begin
        for i := 1 to len do  { parcurgem fiecare caracter }
            if mat[lin+i-1, col-i+1] = '-' then { avem spartiu liber }
                begin
                vec_poz[i] := true; { marcam litera ca pusa intr-un spatiu liber }
                mat[lin+i-1, col-i+1] := st[i]; { adaugam litera }
                end
            else { avem deja un caracter }
                if mat[lin+i-1, col-i+1] <> st[i] then { daca caracterul din matrice nu coincide }
                    begin
                    poz_cuv_4 := false; { nu putem aseja }
                    break;
                    end;
        end
    else { nu avem loc spre stanga }
        poz_cuv_4 := false;
    end;
end;

{ pozitionam cuvantul in stanga }
function poz_cuv_5(lin, col :integer; var c :cuvant):boolean;
var i :integer;
begin
poz_cuv_5 := true; { consideram ca il putem pozitiona }

{ atribuim meta-data }
c.poz_l := lin;
c.poz_c := col;
c.dir:= 5;

with c do
    begin
    if (col-len+1) >= 1 then { avem spatiu }
        begin
        for i := 1 to len do { parcurgem caracterele }
            if mat[lin, col-i+1] = '-' then { avem spatiu liber }
                begin
                vec_poz[i] := true; { marcam caracterul ca introdus intr-un spatiu liber }
                mat[lin, col-i+1] := st[i]; { atribuim caracterul }
                end
            else { exista deja un caracter }
                if mat[lin, col-i+1] <> st[i] then { exista alt caracter  }
                    begin
                    poz_cuv_5 := false; { nu putem pozitiona }
                    break;
                    end;
        end
    else { nu avem spatiu }
        poz_cuv_5 := false;
    end;
end;

{ ====================================================== }
{ proceduri legate de matrice }

{ initializam matricea  }
procedure init_mat(var m:matrice_c; n:integer);
var i, j :integer;
begin
for i := 1 to n do
    for j := 1 to n do
        m[i, j] := '-';
end;

{ afisarea matrici }
procedure afis_mat(var m :matrice_c; n:integer);
var i, j :integer;
begin
for i := 1 to n do
    begin
    for j := 1 to n do
        write(mat[i, j]:3, ' ');
    writeln;
    end;
writeln;
end;

{ ====================================================== }
{ test  }

procedure Interactive;
var i, aux_i, aux_j, aux_n :integer;
    s, cm :string;
    aux_cuv :cuvant;
begin
cm := '';
{ Setup 1 }
writeln('Init matrice 6');
nr_n := 6;
init_mat(mat, nr_n);
afis_mat(mat, nr_n);
{ ENDSetup 1 }
while  lowercase(cm) <> 'q' do 
    begin
    write('>> ');
    readln(cm);

    { pozitionare }
    if cm = 'poz_1' then { daca vrem sa pozitionam spre dreapta }
        begin
        write('i= ');
        readln(aux_i);
        write('j= ');
        readln(aux_j);
        write('s= ');
        readln(s);

        init_cuv(aux_cuv, s);
        poz_cuv_1(aux_i, aux_j, aux_cuv);
        end;
    if cm = 'poz_2' then { daca vrem sa pozitionam spre dreapta }
        begin
        write('i= ');
        readln(aux_i);
        write('j= ');
        readln(aux_j);
        write('s= ');
        readln(s);

        init_cuv(aux_cuv, s);
        poz_cuv_2(aux_i, aux_j, aux_cuv);
        end;
    if cm = 'poz_3' then { daca vrem sa pozitionam spre dreapta }
        begin
        write('i= ');
        readln(aux_i);
        write('j= ');
        readln(aux_j);
        write('s= ');
        readln(s);

        init_cuv(aux_cuv, s);
        poz_cuv_3(aux_i, aux_j, aux_cuv);
        end;
    if cm = 'poz_4' then { daca se doreste pozitionarea spre stanga jos }
        begin
        write('i= ');
        readln(aux_i);
        write('j= ');
        readln(aux_j);
        write('s= ');
        readln(s);
        end;
    if cm = 'poz_5' then { daca se doreste pozitionarea spre stanga jos }
        begin
        write('i= ');
        readln(aux_i);
        write('j= ');
        readln(aux_j);
        write('s= ');
        readln(s);

        init_cuv(aux_cuv, s);
        poz_cuv_5(aux_i, aux_j, aux_cuv);
        end;

    if cm = 'mat' then { daca se doreste afisarea matrici  }
        begin
        afis_mat(mat, nr_n);
        end;

    if cm = 'init_mat' then { daca se doreste initializarea  }
        begin
        write('n= ');
        readln(nr_n);

        init_mat(mat, nr_n);
        end;

    { undo  }
    if cm = 'undo_1' then { stergem cuvantul  }
        begin
        undo_cuv_1(aux_cuv);
        end;
    if cm = 'undo_2' then { stergem cuvantul  }
        begin
        undo_cuv_2(aux_cuv);
        end;
    if cm = 'undo_3' then { stergem cuvantul  }
        begin
        undo_cuv_3(aux_cuv);
        end;
    if cm = 'undo_4' then { stergem cuvantul  }
        begin
        undo_cuv_4(aux_cuv);
        end;
    if cm = 'undo_5' then { stergem cuvantul  }
        begin
        undo_cuv_5(aux_cuv);
        end;

    if cm = 'afis_c' then { afisam informatii despre cuvant }
        begin
        afis_cuv(aux_cuv);
        end;
    end;
end;

{ ====================================================== }
{ test  }

{ verificam daca exista optiunea <s> }
function HasOption(s :string):boolean;
var i :integer;
begin
HasOption := false;
if length(s) = 1 then { short param }
    begin
    for i := 1 to ParamCount do { mergem prin parametri }
        if concat('-', s) = ParamStr(i) then { avem parametrul }
            begin
            HasOption := true;
            break;
            end;
    end
else { long param  }
    begin
    for i := 1 to ParamCount do { mergem prin parametri }
        if concat('--', s) = ParamStr(i) then { avem parametrul }
            begin
            HasOption := true;
            break;
            end;
    end;
end;

{ returnam valoarea parametrului <s> }
function GetValueParam(s :string):string;
var i :integer;
begin
GetValueParam := '';

if length(s) = 1 then
    begin
    for i := 1 to ParamCount do { parcurgem parametri }
        if concat('-', s) = ParamStr(i) then { am gasit parametrul }
            begin
            GetValueParam := ParamStr(i+1); { ii salvam valoarea }
            break;
            end;
    end
else
    begin
    for i := 1 to ParamCount do { parcurgem parametri }
        if concat('--', s) = ParamStr(i) then { am gasit parametrul }
            begin
            GetValueParam := ParamStr(i+1); { ii salvam valoarea }
            break;
            end;
    end;
end;

{ verificam daca a fost pasat macar un argument }
function HasParams:boolean;
begin
HasParams := (ParamCount > 0)
end;


{ handler }
procedure HandleInput;
var f :text;
    something_was_run :boolean;
begin
{ verificam daca exista parametri }
if HasParams then
    begin
    { checking for help  }
    if HasOption('h') or HasOption('help') then
        begin
        writeln('Afisam Help');
        something_was_run := true; { s-a rulat o comanda }
        end
    else { se doreste rulare }
        begin
        { checking for filename problems  }
        if HasOption('f') then
            begin
            writeln('Handle filename -f');
            something_was_run := true; { s-a rulat o comanda }
            end
        else
            if HasOption('file') then
                begin
                writeln('Handle filename --file');
                something_was_run := true; { s-a rulat o comanda }
                end
            else
                begin
                writeln('Handle Error, no fileName given');
                something_was_run := true; { s-a rulat o comanda }
                end;

        { verificam daca se doreste modul interactiv }
        if HasOption('i') or HasOption('interactive') then
            begin
            writeln('Start Interactive Mode');
            something_was_run := true; { s-a rulat o comanda }
            end;
        end;
    end
else
    writeln('Nu s-au pasat parametri, afisam help then');
end;

begin
Interactive;
end.
