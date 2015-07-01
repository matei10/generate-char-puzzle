program creare_puzzle_v2;
{ To Do :
    - git integration #
    - command line option #

    - poz_4 #
    - poz_5 #
    - poz_6 #
    - poz_7 #

    - undo_4 #
    - undo_5 #
    - undo_6 #
    - undo_7 #

    - test poz_4/5/.. si undo_4/5/.. #

    - poz_final #
    - undo_final #
    
    - test poz_final si undo_final #

    - citire cuvinte din fisier #

    - start #
    
    - countere (ramane de stabilit)

    - check_it_can_be_done ( verificam daca cel mai lung cuvant <= nr_n )

    - interactiv mode 

    }
uses SysUtils; { has the function FileExists }
const max_n = 100; { dimensiunea maxima a matrici  }
      max_m = 100; { numarul maxim de cuvinte  }
      max_dir = 7; { numarul de directii }
      { version information }
      version = '2.0.0'; 
      autor = 'Micu Matei-Marius';
      git = 'https://github.com/matei10/generate-char-puzzle';
      gmail = 'micumatei@gmail.com';

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
    nr_cuv, nr_n, len_max :integer;
    rez :boolean;
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
{ procedures related to data structure <cuvant> }

{ construim cuvantul  }
procedure construct_cuv(var c :cuvant);
begin
with c do
    begin
    poz_l := 0; { pozitia de start  }
    poz_c := 0; { pozitia de finish }
    dir := 0; { directia }

    fillbyte(vec_poz, sizeof(vec_poz), 0); { initializam vectorul cu FALSE }
    end;
end;

{ initializam cuvantul  }
procedure init_cuv(var c :cuvant; s :string);
begin
construct_cuv(c); { construim cuvantul }

with c do
    begin
    st := s; { atribuim stringul }
    len := length(s); { atribuim lungimea  }

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

{ stergem cuvantul stiind ca a fost pozitionat pe diagonala principala spre stanga }
procedure undo_cuv_6(var c :cuvant);
var i :integer;
begin
with c do
    begin
    for i := 1 to len do
        if vec_poz[i] then { daca caracteruk <i> a fost pozitionat intr-un loc gol }
            mat[poz_l-i+1, poz_c-i+1] := '-'; { eliminam litera }
    end;
end;

{ stergem cuvantul stiind ca a fost pozitionat in sus  }
procedure undo_cuv_7(var c :cuvant);
var i :integer;
begin
with c do
    begin
    for i := 1 to len do
        if vec_poz[i] then  { daca litera a fost introdusa }
            mat[poz_l-i+1, poz_c] := '-'; { eliminam litera }
    end;
end;

procedure handle_undo_cuv(var c :cuvant);
begin
case c.dir of 
    1: begin { daca cuvantul a fost scris spre dreapta }
        undo_cuv_1(c);
        end;

    2: begin { daca cuvantul a fost scris spre dreapta jos }
        undo_cuv_2(c);
        end;

    3: begin { daca cuvantul a fost scris in jos}
        undo_cuv_3(c);
        end;

    4: begin { daca cuvantul a fost scris in stanga jos}
        undo_cuv_4(c);
        end;

    5: begin { daca cuvantul a fost scris in stanga }
        undo_cuv_5(c);
        end;

    6: begin { daca cuvantul a fost scris stanga sus }
        undo_cuv_6(c);
        end;

    7: begin { daca cuvantul a fost scris in sus }
        undo_cuv_7(c);
        end;
    end;

{ reinitializam cuvantul }
construct_cuv(c);
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

{ ====================================================== }
{ pozitionam un cuvant }

{ pozitionam spre dreapta pornind din pozitia <i>, <j>  }
function poz_cuv_1(lin, col :integer;var c :cuvant):boolean;
var i :integer;
begin
poz_cuv_1 := true; { consideram ca il putem pozitiona }

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

{ pozitionam pe diagonala principala spre stanga , stanga sus  }
function poz_cuv_6(lin, col :integer;var c :cuvant):boolean;
var i :integer;
begin
poz_cuv_6 := true; { presupunem ca putem pozitiona }

with c do
    begin
    if ((col-len+1) >= 1 ) AND ((lin-len+1) >= 1) then { avem loc  }
        begin
        for i := 1 to len do { parcurgem literele  }
            if mat[lin-i+1, col-i+1] = '-' then { daca locul este liber }
                begin
                vec_poz[i] := true; { marcam caracterul ca inserat }
                mat[lin-i+1, col-i+1] := st[i];
                end
            else { locul nu este liber }
                if mat[lin-i+1, col-i+1] <> st[i] then { literele nu coincid }
                    begin
                    poz_cuv_6 := false; { nu putem pozitiona }
                    break; { iesim din loop }
                    end;
        end
    else { nu avem loc  }
        poz_cuv_6 := false;
    end;
end;

{ pozitionam cuvantul in sus  }
function poz_cuv_7(lin, col :integer;var c :cuvant):boolean;
var i :integer;
begin
poz_cuv_7 := true; { consideram ca putem pozitiona }

with c do
    begin
    if (lin-len+1) >= 1 then { avem loc in sus }
        begin
        for i := 1 to len do { parcurgem fiecare caracter }
            if mat[lin-i+1, col] = '-' then { locul este liber }
                begin
                vec_poz[i] := true; { marcam litera ca introdusa in matrice  }
                mat[lin-i+1, col] := st[i]; 
                end
            else { locul nu este liber }
                if mat[lin-i+1, col] <> st[i] then { daca litera nu coincide }
                    begin
                    poz_cuv_7 := false; { nu putem pozitiona }
                    break; { iesim din loop }
                    end;
        end
    else { nu avem loc  }
        poz_cuv_7 := false;
    end;
end;

{ Manageriem Pozitionarea }
function handle_poz_cuv(lin, col, dir :integer;var cuv :cuvant):boolean;
begin
handle_poz_cuv := false;

{ adaugam meta-data }
cuv.poz_l := lin;
cuv.poz_c := col;
cuv.dir := dir;

case dir of
    1 : begin { pozitionare spre dreapta }
        handle_poz_cuv := poz_cuv_1(lin, col, cuv);
        end;

    2 : begin { pozitionam spre dreapta jos }
        handle_poz_cuv := poz_cuv_2(lin, col, cuv);
        end;

    3 : begin { pozitionam in jos }
        handle_poz_cuv := poz_cuv_3(lin, col, cuv);
        end;

    4 : begin { pozitionam spre stanga jos }
        handle_poz_cuv := poz_cuv_4(lin, col, cuv);
        end;

    5 : begin { pozitionam spre stanga }
        handle_poz_cuv := poz_cuv_5(lin, col, cuv);
        end;

    6 : begin { pozitionam spre stanga sus }
        handle_poz_cuv := poz_cuv_6(lin, col, cuv);
        end;

    7 : begin { pozitionam in sus }
        handle_poz_cuv := poz_cuv_7(lin, col, cuv);
        end;
    end;
if not handle_poz_cuv then { daca nu am putut pozitiona }
    handle_undo_cuv(cuv);
end;

{ ====================================================== }
{ File Handling }

function citire_input(s :string):boolean;
var i :integer;
    f :text;
    aux_s :string;
begin
len_max := 0;
if FileExists(s) then { daca fisierul exista }
    begin
    assign(f, s);
    reset(f);

    readln(f, nr_n); { citim ordinul matrici }

    { initializam matricea  }
    init_mat(mat, nr_n);

    readln(f, nr_cuv); { citim numarul de cuvinte }

    { citim cuvintele }
    for i := 1 to nr_cuv do
        begin
        readln(f, aux_s);
        if length(aux_s) > len_max then
            len_max := length(aux_s);

        init_cuv(vec_c[i], aux_s); { initializam cuvantul }
        end;

    citire_input := true;

    end
else { fisierul nu exista }
    citire_input := false;
end;

{ ====================================================== }
{ Starting searching }

procedure start(nr_c :integer);
var lin, col, dir :integer;
begin
{ initializam  }
lin := 1;
col := 1;
dir := 1;

if nr_c <= nr_cuv then { cat timp mai avem cuvinte }
    while (lin <= nr_n) AND (not rez) do { cat timp mai avem linii }
        begin
        col := 1;

        while (col <= nr_n) AND (not rez) do { cat timp mai avem coloane }
            begin
            dir := 1;

            while (dir <= max_dir) AND (not rez) do { cat timp mai avem directii }
                begin
                handle_undo_cuv(vec_c[nr_c]); { reinitializam cuvantul  }

                if handle_poz_cuv(lin, col, dir, vec_c[nr_c]) AND (not rez) then { am reusit sa pozitionam }
                    begin
                    start(nr_c + 1);
                    dir := dir + 1;
                    if not rez then
                        handle_undo_cuv(vec_c[nr_c]); { reinitializam cuvantul  }
                    end
                else { nu am putut pozitiona }
                    dir := dir + 1; { trecem la urmatoarea pozitie }
                end; { end directii }
            col := col + 1; { trecem la urmatoarea coloana }
            end; { end coloane }
        lin := lin + 1; { trecem la urmatoarea linie }
        end { end linii }
else { nu mai avem cuvinte, am terminat }
    rez := true;
end;

{ ====================================================== }
{ Interactive Mode  }

procedure Interactive;
var aux_i, aux_j, aux_d, aux_n :integer;
    cm :string;
begin
cm := ''; { initializam commanda  }

{ ENDSetup 1 }
while  lowercase(cm) <> 'q' do 
    begin
    write('>> ');
    readln(cm);

    { pozitionari  }
    if lowercase(cm) = 'add' then { daugam un cuvant }
        begin
        write('Linie :');
        readln(aux_i);

        write('Coloana :');
        readln(aux_j);

        write('Directie :');
        readln(aux_d);

        write('Numar :');
        readln(aux_n);

        handle_poz_cuv(aux_i, aux_j, aux_d, vec_c[aux_n]);
        end;


    { matrice commands }
    if lowercase(cm) = 'show_mat' then { daca se doreste afisarea matrici  }
        begin
        afis_mat(mat, nr_n);
        end;

    if lowercase(cm) = 'init_mat' then { daca se doreste initializarea  }
        begin
        write('n= ');
        readln(nr_n);

        init_mat(mat, nr_n);
        end;

    { undo  }
    if lowercase(cm) = 'undo' then
        begin
        write('nr :');
        readln(aux_i);
        handle_undo_cuv(vec_c[aux_i]);
        end;

    { cuvant commands }
    if lowercase(cm) = 'show_cuv' then { afisam informatii despre cuvant }
        begin
        write('Numar :');
        readln(aux_n);

        afis_cuv(vec_c[aux_n]);
        end;
    end;
end;

{ ====================================================== }
{ Strings }
procedure help(s :string);
begin
case s of 
    '' :
        begin
        writeln('Scop :');
        writeln('Acest program creeaza o matrice in care se vor regasi toate cuvintele din fisier.');
        writeln('Fisierul este de forma :');
        writeln('<ordin_matrice>');
        writeln('<numar_cuvinte>');
        writeln('<cuvant_1>');
        writeln('<cuvant_2>');
        writeln('<........>');
        writeln('<cuvant_n>');
        writeln;
        writeln('Urmatoarele obtiuni sunt disponibile :');
        writeln(' -f');
        writeln(' --file=name       :fisierul din care citim cuvintele si dimensiunile matrici');
        writeln;
        writeln(' -i');
        writeln(' --interactiv      :acctivam modul interactiv, care ne permite sa manipulam cuvinte');
        writeln;
        writeln(' -v');
        writeln(' --version         :afisam versiunea, si alte informatii');
        end;
    'short': 
        begin
        writeln('Short help');
        end;
    'nu_incape':
        begin
        end;
    end;
end;

{ ====================================================== }
{ Command Line handeling }

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
var something_was_run, start_was_run :boolean;
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
            if citire_input(GetValueParam('f')) then 
                if len_max <= nr_n then { cel mai lung cuvant incape in matrice }
                    begin
                    start(1); { incepem sa rulam programul }
                    something_was_run := true; { s-a rulat o comanda }
                    start_was_run := true; { s-a rulat startu }
                    end
                else
                    begin
                    help('nu_incape');
                    help('short');
                    end
            else
                begin
                writeln('ERROR: Fisierul nu a fost gasit !');
                help('short'); { Afisam un mic ajutor }
                end;
            end
        else
            if HasOption('file') then
                begin
                if citire_input(GetValueParam('file')) then 
                    if len_max <= nr_n then
                        begin
                        start(1); { incepem sa rulam programul }
                        something_was_run := true; { s-a rulat o comanda }
                        start_was_run := true; { s-a rulat startu }
                        end
                    else
                        begin
                        help('nu_incape');
                        help('short');
                        end
                else
                    begin
                    writeln('ERROR: Fisierul nu a fost gasit !');
                    help('short'); { Afisam un mic ajutor }
                    end;
                end
            else
                begin
                writeln('Handle Error, no fileName given');
                something_was_run := true; { s-a rulat o comanda }
                help('short'); { Afisam un mic ajutor }
                end;

        if start_was_run then
            if rez then { daca am rezolvar }
                begin
                writeln('Rezolvare :');
                afis_mat(mat, nr_n);
                end
            else
                writeln('Nu Am rezolvat');

        { verificam daca se doreste modul interactiv }
        if HasOption('i') or HasOption('interactive') then
            begin
            Interactive;
            something_was_run := true; { s-a rulat o comanda }
            end;
        end;
    end
else { daca nu s-au adaugat parametri }
    help('short'); { Afisam un mic ajutor }

if not something_was_run then { daca nu s-a rulat nimic }
    help('short'); { Afisam un mic ajutor }


end;

begin
HandleInput;
(* Interactive; *)
end.
