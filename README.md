# generate-char-puzzle

Acest program este scris in FreePascal si va genereaza o matrice un pozzle in care un numar de cuvinte se pot regasi citite, de la dreapta la stanga, in sus in jos si invers, si pe toate diagonalele.

# Folosire:
Puteti folosi varianta compilata de mine `program` a fost compilat cu
`Free Pascal Compiler version 2.6.2-8 [2014/01/22] for x86_64         
Copyright (c) 1993-2012 by Florian Klaempfl and others        
Target OS: Linux for x86-64     `     

sau puteti compila codul sursa.


 Scop :
 Acest program creeaza o matrice in care se vor regasi toate cuvintele din fisier.

 Fisierul este de forma :

 ordin_matrice  
 numar_cuvinte  
 cuvant_1  
 cuvant_2  
 ........  
 cuvant_n    
    
   
 Urmatoarele obtiuni sunt disponibile :  
`  -f  `
`  --file=name      `   : fisierul din care citim cuvintele si dimensiunile matrici  
  
`  -i  `
 ` --interactiv    `   : acctivam modul interactiv, care ne permite sa manipulam cuvinte  
  
`  -v  `
`  --version    `       : afisam versiunea, si alte informatii  
  
 ` -d  `
  `  --debug=true/false ` : valoarea default este false, dar daca se rescrie, se vor afisa diferite  
                        valori auxiliare
  
`  -c  `
`  --create=name  `     : se intra in modul care ajuta la creearea unui fisier input   
                        daca un nume nu este precizat atunci se va folosi defaul.txt   
   
`  -h  `
`  --help      `        : afisam ajutorul acesta   


# Exemplu 

### Fisierul de intrare 
4  
5  
ana  
argo  
nora  
moro    
toor    
  
    
### Va produce   
Rezolvare :   
`  a   n   a   m   `  
`  r   o   o   t   `  
`  g   r   -   -   `  
`  o   a   -   -   `  
  
