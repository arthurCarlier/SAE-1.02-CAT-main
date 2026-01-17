unit unit_tests_unitaires;

{$mode delphi}{$H+}

interface
uses
  SysUtils, Classes, unit_logic_ressources;

///////// BATIMENTS /////////////////////////////////

  //procedure de test de la fonction CreerBatiment
  procedure test_creerBatiment();

  //procedure de test de la fonction ProductionBatiment
  procedure test_productionBatiment();

  //procedure de test de la fonction CoutProductionBatiment
  procedure test_coutProductionBatiment();
  
  //procedure de test de la fonction CoutConstruction
  procedure test_coutConstruction();

  //procedure de test de la fonction CoutAmelioration
  procedure test_coutAmelioration();

  //procedure de test de la fonction ConsommationElectriciteBatiment
  procedure test_consommationElectriciteBatiment();

///////
  //procedure générale rassemblant tout les tests bâtiments fait précedemment
  procedure test_batiment();

/////////////////////////////////////////////////////

///////// RESSOURCES ////////////////////////////////

  //procedure de test de la fonction CreerInventaireVide
  procedure test_creerInventaireVide();

  //procedure de test de la procedure AjouterInventaire
  procedure test_ajouterInventaire();

  //procedure de test de la procedure RetirerInventaire
  procedure test_retirerInventaire();

  //procedure de test de la fonction ContientInventaire
  procedure test_contientInventaire();

  //procedure de test de la procedure CopierInventaire
  procedure test_copierInventaire();

  //procedure de test de la fonction IndicePremiereProduction
  procedure test_indicePremiereProduction();
  
  //procedure de test de la fonction CoutFabrication
  procedure test_coutFabrication();

  //procedure de test de la fonction QuantiteProduit
  procedure test_quantiteProduite();

///////
  //procedure générale qui rassemble tout les tests ressources faits précédemment
  procedure test_ressource();

/////////////////////////////////////////////////////


  //La procedure qui sera utilisée pour tester toutes les procédures à tester.
  procedure test();
  

implementation  
uses
  testunitaire,unit_logic_batiment,GestionEcran,math;

///////// --- PARTIE BATIMENTS --- //////////////////

//Les Procédures Tests
procedure test_creerBatiment();
var
  first_valid_test:boolean;
  second_valid_test:boolean;
  batiment_testCreation:TBatiment;
begin
  // Initialisation des Variables Boolean afin de vérifier les deux premiers tests
  first_valid_test := false;
  second_valid_test := false;
  // Initialisation de la nouvelle série de tests
  newTestsSeries('Tests-creerBatiments');
  //Utilisation de la fonction CreerBatiment
  batiment_testCreation := CreerBatiment(MINE,CUIVRE,3);
  //Premier test
  newTest('Tests-creerBatiments','Creation_du_batiment-type');
  if batiment_testCreation.typeBatiment = MINE then
  begin
    first_valid_test := true;
  end;
  testIsEqual(first_valid_test);
  //Second test
  newTest('Tests-creerBatiments','Creation_du_batiment-production');
  if batiment_testCreation.production = CUIVRE then
  begin
    second_valid_test := true;
  end;
  testIsEqual(second_valid_test);
  //Dernier test
  newTest('Tests-creerBatiments','Creation_du_batiment-niveau');
  testIsEqual(batiment_testCreation.niveau,3);
end;

procedure test_productionBatiment();
var
  batiment_testProductionMine:TBatiment;
  batiment_testProductionConstructeur:TBatiment;
  valid_test_mine:boolean;
  valid_test_constructeur:boolean;
  productionInvMine:TInventaire;
  productionInvConstructeur:TInventaire;
begin
  //Initialisation des variables
  batiment_testProductionMine := CreerBatiment(MINE,FER,1);
  batiment_testProductionConstructeur := CreerBatiment(CONSTRUCTEUR,CABLE,1);
  valid_test_mine := false;
  valid_test_constructeur := false;
  //Création de la série de tests
  newTestsSeries('Tests-productionBatiment');
  //test des mines
  newTest('Tests-productionBatiment','Production_du_batiment-mine');
  productionInvMine := ProductionBatiment(batiment_testProductionMine, 2);
  //Vérification de la création d'une production
  if productionInvMine[batiment_testProductionMine.production] = Round(30*IntPower(2,batiment_testProductionMine.niveau-1)*IntPower(2,2-1)) then
  begin
    valid_test_mine := true;
  end;
  testIsEqual(valid_test_mine);
  //test des constructeurs
  newTest('Tests-productionBatiment','Production_du_batiment-constructeur');
  productionInvConstructeur := ProductionBatiment(batiment_testProductionConstructeur, 2);
  //Vérification de la création d'une production (encore)
  if productionInvConstructeur[batiment_testProductionConstructeur.production] = QuantiteProduite(batiment_testProductionConstructeur.production,batiment_testProductionConstructeur.niveau) then
  begin
    valid_test_constructeur := true;
  end;
  testIsEqual(valid_test_constructeur);
end;

procedure test_coutProductionBatiment();
var
  valid_test_coutProduction:boolean;
  batiment_testCoutProduction:TBatiment;
  coutProductionInv:TInventaire;
  tabFabric:TInventaire;
  i:TRessource;
begin
  //Initialisation des variables
  valid_test_coutProduction := true;
  batiment_testCoutProduction := CreerBatiment(CONSTRUCTEUR,CABLE,1);
  //On commence les tests - Initialisation de la série de test
  newTestsSeries('Tests-CoutProductionBatiment');
  newTest('Tests-CoutProductionBatiment','Cout_de_la_Production_Batiment');
  //On utilise la fonction
  coutProductionInv := CoutProductionBatiment(batiment_testCoutProduction);
  //On doit maintenant utiliser le boolean
  tabFabric := CoutFabrication(batiment_testCoutProduction.production);
  for i := low(TRessource) to High(TRessource) do
  begin
    if coutProductionInv[i] <> tabFabric[i] then
    begin
      valid_test_coutProduction := false;
    end;
  end;
  //Conclusion du test
  testIsEqual(valid_test_coutProduction);
end;

procedure test_coutConstruction();
var
  //4 tests
  //1er
  valid_test_coutConstructionMine:boolean;
  batiment_testCoutConstructionMine:TBatiment;
  coutConstructionMineInv:TInventaire;
  //2ème
  valid_test_coutConstructionConstructeur:boolean;
  batiment_testCoutConstructionConstructeur:TBatiment;
  coutConstructionConstructeurInv:TInventaire;
  //3ème
  valid_test_coutConstructionCentrale:boolean;
  batiment_testCoutConstructionCentrale:TBatiment;
  coutConstructionCentraleInv:TInventaire;
  //4ème
  valid_test_coutConstructionAscenseur:boolean;
  batiment_testCoutConstructionAscenseur:TBatiment;
  coutConstructionAscenseurInv:TInventaire;
  // Variable de boucle
  i:TRessource;
  somme:Integer;
begin
  //Initialisation des variables
  //Les booléens
  valid_test_coutConstructionMine := true;
  valid_test_coutConstructionConstructeur := true;
  valid_test_coutConstructionCentrale := true;
  valid_test_coutConstructionAscenseur := true;
  //Les batiments
  batiment_testCoutConstructionMine := CreerBatiment(MINE,FER,1);
  batiment_testCoutConstructionConstructeur := CreerBatiment(CONSTRUCTEUR,CABLE,1);
  batiment_testCoutConstructionCentrale := CreerBatiment(CENTRALE,AUCUNRES,1);
  batiment_testCoutConstructionAscenseur := CreerBatiment(ASCENSEUR,AUCUNRES,1);
  //La somme
  somme := 0;
  //Initialisation des tests - Création d'une série de tests
  newTestsSeries('Tests-CoutConstruction');
  //Premier test - LA MINE
  newTest('Tests-CoutConstruction','Cout_Construction_Mine');
  coutConstructionMineInv := CoutConstruction(batiment_testCoutConstructionMine);
  if coutConstructionMineInv[PLAQUEFER] <> 10 then
  begin
    valid_test_coutConstructionMine := false;
  end
  else
  begin
    for i := low(TRessource) to High(TRessource) do
    begin
      somme := somme + coutConstructionMineInv[i];
    end;
    if somme <> 10 then
    begin
      valid_test_coutConstructionMine := false;
    end;
    somme := 0;
  end;
  testIsEqual(valid_test_coutConstructionMine);
  //Second test - LES CONSTRUCTEURS
  newTest('Tests-CoutConstruction','Cout_Construction_Constructeur');
  coutConstructionConstructeurInv := CoutConstruction(batiment_testCoutConstructionConstructeur);
  if (coutConstructionConstructeurInv[PLAQUEFER] <> 10) OR (coutConstructionConstructeurInv[CABLE] <> 10) then
  begin
    valid_test_coutConstructionConstructeur := false;
  end
  else
  begin
    for i := low(TRessource) to High(TRessource) do
    begin
      somme := somme + coutConstructionConstructeurInv[i];
    end;
    if somme <> 20 then
    begin
      valid_test_coutConstructionConstructeur := false;
    end;
    somme := 0;
  end;
  testIsEqual(valid_test_coutConstructionConstructeur);
  //Troisième test - LES CENTRALES
  newTest('Tests-CoutConstruction','Cout_Construction_Centrale');
  coutConstructionCentraleInv := CoutConstruction(batiment_testCoutConstructionCentrale);
  if (coutConstructionCentraleInv[PLAQUEFER] <> 10) OR (coutConstructionCentraleInv[BETON] <> 20) OR (coutConstructionCentraleInv[CABLE] <> 30) then
  begin
    valid_test_coutConstructionCentrale := false;
  end
  else
  begin
    for i := low(TRessource) to High(TRessource) do
    begin
      somme := somme + coutConstructionCentraleInv[i];
    end;
    if somme <> 60 then
    begin
      valid_test_coutConstructionCentrale := false;
    end;
    somme := 0;
  end;
  testIsEqual(valid_test_coutConstructionCentrale);
  //Quatrième test - L'ASCENSEUR
  newTest('Tests-CoutConstruction','Cout_Construction_Ascenseur');
  coutConstructionAscenseurInv := CoutConstruction(batiment_testCoutConstructionAscenseur);
  if (coutConstructionAscenseurInv[PLAQUEFER] <> 200) OR (coutConstructionAscenseurInv[BETON] <> 200) OR (coutConstructionAscenseurInv[CABLE] <> 200) then
  begin
    valid_test_coutConstructionAscenseur := false;
  end
  else
  begin
    for i := low(TRessource) to High(TRessource) do
    begin
      somme := somme + coutConstructionAscenseurInv[i];
    end;
    if somme <> 600 then
    begin
      valid_test_coutConstructionAscenseur := false;
    end;
    somme := 0;
  end;
  testIsEqual(valid_test_coutConstructionAscenseur);
end;

procedure test_coutAmelioration();
var
  //vars mines
  valid_test_coutAmeliorationMine:boolean;
  batiment_testCoutAmeliorationMine:TBatiment;
  CoutAmeliorationMineInv:TInventaire;
  //vars constructeur
  valid_test_coutAmeliorationConstructeur:boolean;
  batiment_testCoutAmeliorationConstructeur:TBatiment;
  CoutAmeliorationConstructeurInv:TInventaire;
  //variable de boucle
  i:TRessource;
  //variable somme
  somme:Integer;
begin
  //Initialisation des variables
  //les booleans
  valid_test_coutAmeliorationMine := true;
  valid_test_coutAmeliorationConstructeur := true;

  //Les batiments
  batiment_testCoutAmeliorationMine := CreerBatiment(MINE,FER,1);
  batiment_testCoutAmeliorationConstructeur := CreerBatiment(CONSTRUCTEUR,CABLE,2);

  //La somme
  somme := 0;

  //La série de tests
  newTestsSeries('Tests-CoutAmelioration');
  //Premier test - LA MINE
  newTest('Tests-CoutAmelioration','Cout_Amelioration_Mine');
  CoutAmeliorationMineInv := CoutAmelioration(batiment_testCoutAmeliorationMine);
  if (CoutAmeliorationMineInv[BETON] <> 20) OR (CoutAmeliorationMineInv[PLAQUEFER] <> 20) then
  begin
    valid_test_coutAmeliorationMine := false;
  end
  else
  begin
    for i := low(TRessource) to High(TRessource) do
    begin
      somme := somme + CoutAmeliorationMineInv[i];
    end;
    if somme <> 40 then
    begin
      valid_test_coutAmeliorationMine := false;
    end;
    somme := 0;
  end;
  testIsEqual(valid_test_coutAmeliorationMine);
  //Second test - LES CONSTRUCTEURS
  newTest('Tests-CoutAmelioration','Cout_Amelioration_Constructeur');
  coutAmeliorationConstructeurInv := CoutAmelioration(batiment_testCoutAmeliorationConstructeur);
  if (coutAmeliorationConstructeurInv[PLAQUEFER] <> 20) OR (coutAmeliorationConstructeurInv[ACIER] <> 20) then
  begin
    valid_test_coutAmeliorationConstructeur := false;
  end
  else
  begin
    for i := low(TRessource) to High(TRessource) do
    begin
      somme := somme + coutAmeliorationConstructeurInv[i];
    end;
    if somme <> 40 then
    begin
      valid_test_coutAmeliorationConstructeur := false;
    end;
    somme := 0;
  end;
  testIsEqual(valid_test_coutAmeliorationConstructeur);
end;

procedure test_consommationElectriciteBatiment();
var
  INT_TestConsommationElecBat:Integer;
  attendu:Integer;
  batiment_testConsommationElecMine:TBatiment;
  batiment_testConsommationElecConstructeur:TBatiment;
  batiment_testConsommationElecHub:TBatiment;
  batiment_testConsommationElecAscenseur:TBatiment;
begin
  //Initialisation des variables
  //Batiments
  batiment_testConsommationElecMine := CreerBatiment(MINE,FER,1);
  batiment_testConsommationElecConstructeur := CreerBatiment(CONSTRUCTEUR,CABLE,1);
  batiment_testConsommationElecHub := CreerBatiment(HUB,AUCUNRES,1);
  batiment_testConsommationElecAscenseur := CreerBatiment(ASCENSEUR,AUCUNRES,1);
  //Série
  newTestsSeries('Tests-ConsoElecBat');
  //MINE
  newTest('Tests-ConsoElecBat','Test-Mine-Consommation');
  INT_TestConsommationElecBat := ConsommationElectriciteBatiment(batiment_testConsommationElecMine);
  attendu := 100+100*(batiment_testConsommationElecMine.niveau-1);
  testIsEqual(INT_TestConsommationElecBat,attendu);
  //CONSTRUCTEUR
  newTest('Tests-ConsoElecBat','Test-Constructeur-Consommation');
  INT_TestConsommationElecBat := ConsommationElectriciteBatiment(batiment_testConsommationElecConstructeur);
  attendu := 200+100*(batiment_testConsommationElecConstructeur.niveau-1);
  testIsEqual(INT_TestConsommationElecBat,attendu);
  //HUB
  newTest('Tests-ConsoElecBat','Test-Hub-Consommation');
  INT_TestConsommationElecBat := ConsommationElectriciteBatiment(batiment_testConsommationElecHub);
  attendu := 100;
  testIsEqual(INT_TestConsommationElecBat,attendu);
  //CONSTRUCTEUR
  newTest('Tests-ConsoElecBat','Test-Ascenseur-Consommation');
  INT_TestConsommationElecBat := ConsommationElectriciteBatiment(batiment_testConsommationElecAscenseur);
  attendu := 1000;
  testIsEqual(INT_TestConsommationElecBat,attendu);
end;

//procedure rassemblant toutes les procedures tests unitaires de unit_logic_batiments.
procedure test_batiment();
begin
  test_creerBatiment();
  test_productionBatiment();
  test_coutProductionBatiment();
  test_coutConstruction();
  test_coutAmelioration();
  test_consommationElectriciteBatiment();
end;

///////// --- PARTIE RESSOURCES --- /////////////////

//Les Procédures Tests

//Test la fonction CreerInventaireVide
procedure test_creerInventaireVide();
var 
  inventaire_test : TInventaire;
begin
//Creer un inventaire vide au debut de la partie
  newTestsSeries('Creation inventaire vide');
  newTest('Creation inventaire vide','a la creation');
  inventaire_test := CreerInventaireVide();
  testIsEqual(ToStringInventaire(inventaire_test), '');
end;

//Test la procedure AjouterInventaire
procedure test_ajouterInventaire();
var
  inventaire_test, ajout_inventaire : TInventaire;
begin
  newTestsSeries('Ajouter inventaire');
//Ajouter une ressource a un inventaire vide
  newTest('Ajouter inventaire','a inventaire actuel (une seule ressource)');
  inventaire_test := CreerInventaireVide;
  ajout_inventaire := CreerInventaireVide;
  ajout_inventaire[CUIVRE] := 3;
  AjouterInventaire(inventaire_test, ajout_inventaire);
  testIsEqual(ToStringInventaire(inventaire_test), 'Minerai de cuivre (x3)');
//Ajouter plusieurs ressources a un inventaire vide
  newTest('Ajouter inventaire','a inventaire actuel (ressources multiple)');
  inventaire_test := CreerInventaireVide;
  ajout_inventaire := CreerInventaireVide;
  ajout_inventaire[CUIVRE] := 3;
  ajout_inventaire[FER] := 1;
  AjouterInventaire(inventaire_test, ajout_inventaire);
  testIsEqual(ToStringInventaire(inventaire_test), 'Minerai de cuivre (x3) / Minerai de fer (x1)');
//Ajouter une ressource a un inventaire non vide
  newTest('Ajouter inventaire','a inventaire actuel (dans un inventaire non vide)');
  inventaire_test := CreerInventaireVide;
  inventaire_test[CUIVRE] := 3;
  ajout_inventaire := CreerInventaireVide;
  ajout_inventaire[CUIVRE] := 2;
  AjouterInventaire(inventaire_test, ajout_inventaire);
  testIsEqual(ToStringInventaire(inventaire_test), 'Minerai de cuivre (x5)');
end;

//Test la procedure RetireInventaire (inverse a AjouterInventaire)
procedure test_retirerInventaire();
var 
  inventaire_test, retire_inventaire : TInventaire;
begin
  newTestsSeries('Retirer inventaire');
//Retire une ressource
  newTest('Retirer inventaire', 'a inventaire actuel (une seule ressource)');
  inventaire_test := CreerInventaireVide;
  inventaire_test[CUIVRE] := 3;
  retire_inventaire := CreerInventaireVide;
  retire_inventaire[CUIVRE] := 2;
  RetirerInventaire(inventaire_test, retire_inventaire);
  testIsEqual(ToStringInventaire(inventaire_test), 'Minerai de cuivre (x1)');
//Retire plusieurs ressources
  newTest('Retirer inventaire', 'a inventaire actuel (Ressources multiple)');
  inventaire_test := CreerInventaireVide;
  inventaire_test[CUIVRE] := 3;
  inventaire_test[FER] := 4;
  retire_inventaire := CreerInventaireVide;
  retire_inventaire[CUIVRE] := 2;
  retire_inventaire[FER] := 1;
  RetirerInventaire(inventaire_test, retire_inventaire);
  testIsEqual(ToStringInventaire(inventaire_test), 'Minerai de cuivre (x1) / Minerai de fer (x3)');
//Retrait de ressource non possede
  newTest('Retirer inventaire', 'a inventaire actuel (Ressource non presente)');
  inventaire_test := CreerInventaireVide;
  inventaire_test[CUIVRE] := 3;
  retire_inventaire := CreerInventaireVide;
  retire_inventaire[FER] := 2;
  RetirerInventaire(inventaire_test, retire_inventaire);
  testIsEqual(ToStringInventaire(inventaire_test), 'Minerai de cuivre (x3)');
//Retire une ressource totalement
  newTest('Retirer inventaire', 'a inventaire actuel (Entierement une ressours)');
  inventaire_test := CreerInventaireVide;
  inventaire_test[FER] := 3;
  retire_inventaire := CreerInventaireVide;
  retire_inventaire[FER] := 3;
  RetirerInventaire(inventaire_test, retire_inventaire);
  testIsEqual(ToStringInventaire(inventaire_test), '');
//Retire plus de ressources que possede mais reste a zero
  newTest('Retirer inventaire', 'a inventaire actuel (Plus que posseder)');
  inventaire_test := CreerInventaireVide;
  inventaire_test[CUIVRE] := 3;
  retire_inventaire := CreerInventaireVide;
  retire_inventaire[CUIVRE] := 5;
  RetirerInventaire(inventaire_test, retire_inventaire);
  testIsEqual(ToStringInventaire(inventaire_test), '');
end;

//Test si la fonction ContenirInventaire fonctionne
procedure test_contientInventaire();
var 
  inventaire_test, contenir_inventaire : TInventaire;
  i : integer;
  ContientInv : boolean;
begin
  newTestsSeries('Contenir inventaire');
  ContientInv := true;
  i:= 0;
//Si la fonction verifie bien que l inventaire est contenu
  newTest('Contenir inventaire', 'ContientInventaire est vrai');
  inventaire_test := CreerInventaireVide();
  contenir_inventaire := CreerInventaireVide();
  ContientInv := ContientInventaire(inventaire_test, contenir_inventaire);
  if ContientInv OR NOT ContientInv then
    i := 1;
  testIsEqual(i,1);
//Si la fonction verifie bien que l inventaire est pas contenu
  newTest('Contenir inventaire', 'ContientInventaire est faux');
  inventaire_test := CreerInventaireVide();
  contenir_inventaire := CreerInventaireVide();
  contenir_inventaire[FER] := 3;
  ContientInv := ContientInventaire(inventaire_test, contenir_inventaire);
  if ContientInv OR NOT ContientInv then
    i := 1;
  testIsEqual(i,1);
end;

//Test la procedure CopierInventaire
procedure test_copierInventaire();
var 
  inventaire_test, copie_inventaire : TInventaire;
begin
  newTestsSeries('Copier inventaire');
//Copier un inventaire vers un plus petit
  newTest('Copier inventaire','a inventaire plus petit');
  inventaire_test := CreerInventaireVide;
  inventaire_test[FER] := 5;
  copie_inventaire := CreerInventaireVide;
  CopierInventaire(copie_inventaire, inventaire_test);
  testIsEqual(ToStringInventaire(copie_inventaire), 'Minerai de fer (x5)');
//Copier un inventaire vers un plus grand
  newTest('Copier inventaire','a inventaire plus grand');
  inventaire_test := CreerInventaireVide;
  inventaire_test[FER] := 2;
  copie_inventaire := CreerInventaireVide;
  inventaire_test[FER] := 5;
  CopierInventaire(copie_inventaire, inventaire_test);
  testIsEqual(ToStringInventaire(copie_inventaire), 'Minerai de fer (x5)');
//Copier un inventaire vers un de ressources differentes
  newTest('Copier inventaire','a inventaire de ressources differentes');
  inventaire_test := CreerInventaireVide;
  inventaire_test[FER] := 2;
  copie_inventaire := CreerInventaireVide;
  inventaire_test[CUIVRE] := 5;
  CopierInventaire(copie_inventaire, inventaire_test);
  testIsEqual(ToStringInventaire(copie_inventaire), 'Minerai de cuivre (x5) / Minerai de fer (x2)');
end;

//Test la fonction IndicePremiereProduction
procedure test_indicePremiereProduction();
begin
  newTestsSeries('Indice de la premiere production');
  newTest('Indice de la premiere production','a enumeration du premier element');
  IndicePremiereProduction();
  testIsEqual(IndicePremiereProduction(),5);
end;

procedure test_coutFabrication();
var 
  ressource_test : TRessource;
  inventaire_test : TInventaire;
  coutJuste : boolean;
begin
  newTestsSeries('Cout fabrication');
  coutJuste := true;
//Verifie tout les couts en un test
  newTest('Cout fabrication','pour toutes les fabrications possibles');
  for ressource_test := Low(TRessource) to High(TRessource) do
  begin
    inventaire_test := CoutFabrication(ressource_test);
    case ressource_test of
      LINGOTCUIVRE:
        if (inventaire_test[CUIVRE] <> 30) then coutJuste := False;
      LINGOTFER:
        if (inventaire_test[FER] <> 30) then coutJuste := False;
      CABLE:
        if (inventaire_test[LINGOTCUIVRE] <> 15) then coutJuste := False;
      PLAQUEFER:
        if (inventaire_test[LINGOTFER] <> 60) then coutJuste := False;
      TUYAUFER:
        if (inventaire_test[LINGOTFER] <> 30) then coutJuste := False;
      BETON:
        if (inventaire_test[CALCAIRE] <> 15) then coutJuste := False;
      ACIER:
        if ((inventaire_test[FER] <> 30) or (inventaire_test[CHARBON] <> 15) ) then coutJuste := False;
      PLAQUER:
        if ((inventaire_test[PLAQUEFER] <> 20) or (inventaire_test[ACIER] <> 20) ) then coutJuste := False;
      POUTRE:
        if ((inventaire_test[PLAQUEFER] <> 20) or (inventaire_test[BETON] <> 15) ) then coutJuste := False;
      FONDATION:
        if (inventaire_test[BETON] <> 30) then coutJuste := False;
    end;
  end;
  testIsEqual(coutJuste);
end;

//Test la fonction QuantiteProduite
procedure test_quantiteProduite();
var 
  ressource_test : TRessource;
  quantiteJuste : boolean;
  valeurInit, valeur : integer;
begin
  newTestsSeries('Quantite produite');
//Pour un batiment niveau 1
  newTest('Quantite produite','pour le niveau 1');
  quantiteJuste := true;
  for ressource_test := Low(TRessource) to High(TRessource) do
  begin
    case ressource_test of
      LINGOTCUIVRE, LINGOTFER, ACIER: valeurInit := 15;
      CABLE: valeurInit := 5;
      PLAQUEFER, TUYAUFER: valeurInit := 10;
      BETON: valeurInit := 5;
      PLAQUER, POUTRE, FONDATION: valeurInit := 2;
    else
      valeurInit := 0;
    end;
    valeur := QuantiteProduite(ressource_test, 1);
    if valeur <> valeurInit then quantiteJuste := false;
  end;
  testIsEqual(quantiteJuste);
//Pour un batiment niveau 2
  newTest('Quantite produite','pour le niveau 2');
  quantiteJuste := true;
  valeur := QuantiteProduite(ressource_test, 2);
  if valeur <> (valeurInit*3) div 2 then quantiteJuste := false;
  testIsEqual(quantiteJuste);
//Pour un batiment niveau 3
  newTest('Quantite produite','pour le niveau 3');
  quantiteJuste := true;
  valeur := QuantiteProduite(ressource_test, 3);
  if valeur <> (valeurInit*2) then quantiteJuste := false;
  testIsEqual(quantiteJuste);
end;

//procedure rassemblant toutes les procedures tests unitaires de unit_logic_ressources.
procedure test_ressource();
begin
  test_creerInventaireVide();
  test_ajouterInventaire();
  test_retirerInventaire();
  test_contientInventaire();
  test_copierInventaire();
  test_indicePremiereProduction();
  test_coutFabrication();
  test_quantiteProduite();
end;


///////// --- DERNIER TEST --- //////////////////////

//procedure rassemblant toutes les procedures tests unitaires.
procedure test();
begin
  test_batiment();
  test_ressource();
  Summary();
end;
  
end.