unit unit_ihm_batiments;
{$codepage utf8}  
{$mode objfpc}{$H+}

interface
uses
  unit_logic_lieu;
  
//Changement de production
//numeroZone : numéro de la zone
function AmeliorerBatimentZone(numeroZone : integer) : TLieu;
  
//Ecran de Construction d'un batiment
//numeroZone : numéro de la zone
function Construction(numeroZone : integer) : TLieu;

//Construction d'un batiement
//numeroZone : numero de la zone
//numeroEmplacement : numero de l'emplacement
procedure Construire(numeroZone : integer; numeroEmplacement : integer);
 
//Fait choisir la production de l'usine
//numeroZone : numero de la zone
//numeroEmplacement : numero de l'emplacement
procedure ChoixProductionConstructeur(numeroZone : integer; numeroEmplacement : integer);

//Changement de production
//numeroZone : numero de la zone
function ChangerProduction(numeroZone : integer) : TLieu;

implementation
uses
  GestionEcran,math,unit_logic_outils,SysUtils,unit_ihm_zone,unit_logic_batiment,unit_logic_ressources,unit_ihm_outils,unit_logic_zone;
  
//Ecran de Construction d'un batiment
//numeroZone : numéro de la zone
function Construction(numeroZone : integer) : TLieu;
var
  positionSelectionne : integer;
  mouvement : TMouvementMenu;
  laZone : TZone;
begin

  //On récupère la zone
  laZone := GetZone(numeroZone);

  EffacerMenu();
  couleurTexte(Cyan);
  EcrireMenu(3,'  < Selectionnez un emplacement >');

  positionSelectionne := 0;
  mouvement := SelectionEmplacementClavier(laZone,positionSelectionne);

  if(mouvement = VALIDER) then Construire(numeroZone,positionSelectionne);

  Construction := ZONE;
end;

//Construction d'un batiement
//numeroZone : numero de la zone
//numeroEmplacement : numero de l'emplacement
procedure Construire(numeroZone : integer; numeroEmplacement : integer);
var
  choix : integer;
  batiment : TBatiment;
  zone : TZone;
begin
  
  //On récupère la zone
  zone := GetZone(numeroZone);

  EffacerMenu();

  //Si l'emplacement est inconnu
  if(not(zone.emplacements[numeroEmplacement].estConnu)) then
  begin
    couleurTexte(Red);
    EcrireMenu(3,'    Impossible de construire ici');
    EcrireMenu(4,'       Emplacement non connu !');
    readln;
  end
  //Si l'emplacement est déja occupé
  else if zone.emplacements[numeroEmplacement].batiment.typeBatiment <> AUCUNBAT then
  begin
    couleurTexte(Red);
    EcrireMenu(3,'    Impossible de construire ici');
    EcrireMenu(4,'        Emplacement occupé !');
    readln;
  end
  //Sinon c'est bon
  else
  begin
    couleurTexte(White);
    
    EcrireMenu(0,'Quel bâtiment voulez vous construire ?');
    EcrireMenu(1,'  1/ Construire une mine');
    EcrireMenu(2,'  2/ Construire un constructeur');
    EcrireMenu(3,'  3/ Construire une centrale');
    EcrireMenu(4,'  4/ Construire l''ascenseur orbital');
    
    choix := -1;
    while(choix = -1) do 
    begin
      ZoneReponse();
      choix := NormalisationChoix(1,5);
    end;
    case choix of
      1: batiment := CreerBatiment(MINE,AUCUNRES,1);
      2: batiment := CreerBatiment(CONSTRUCTEUR,AUCUNRES,1);
      3: batiment := CreerBatiment(CENTRALE,AUCUNRES,1);
      4: batiment := CreerBatiment(ASCENSEUR,AUCUNRES,0);
    end;

    //Tester si on a les ressources pours
    if ContientInventaire(zone.inventaire,CoutConstruction(batiment)) then
    begin
      //Essayer de le construire
      if(AjouterBatiment(batiment,numeroZone,numeroEmplacement)) then
      begin
        //Cas des constructeurs (choix de la production)
        if(batiment.typeBatiment = CONSTRUCTEUR) then ChoixProductionConstructeur(numeroZone,numeroEmplacement);
        EffacerMenu();
        couleurTexte(Green);
        EcrireMenu(3,'       Construction réussie !');
        readln;
      end
      else
      begin
        EffacerMenu();
        couleurTexte(Red);
        EcrireMenu(3,'    Impossible de construire ici');
        case batiment.typeBatiment of
          Mine : EcrireMenu(4,'  Aucun gisement à cet emplacement !');
          ASCENSEUR : EcrireMenu(4,'Un seul ascenseur peut être construit !');
          else EcrireMenu(4,'      Emplacement non valide !');
        end;
        readln;
      end;
    end
    else
    begin
        EffacerMenu();
        couleurTexte(Red);
        EcrireMenu(3,' Impossible de construire ce bâtiment');
        EcrireMenu(4,'    Il vous manque des ressources');
        readln;
    end;

  end;
end;

//Changement de production
//numeroZone : numero de la zone
function ChangerProduction(numeroZone : integer) : TLieu;
var
  positionSelectionne : integer;
  mouvement : TMouvementMenu;
  laZone : TZone;
begin

  //On récupère la zone
  laZone := GetZone(numeroZone);

  EffacerMenu();
  couleurTexte(Cyan);
  EcrireMenu(3,'  < Selectionnez un constructeur >');

  positionSelectionne := 0;
  mouvement := SelectionEmplacementClavier(laZone,positionSelectionne);

  if(mouvement = VALIDER)  then 
  begin
    if(laZone.emplacements[positionSelectionne].batiment.typeBatiment = CONSTRUCTEUR) then ChoixProductionConstructeur(numeroZone,positionSelectionne)
    else
    begin
        EffacerMenu();
        couleurTexte(Red);
        EcrireMenu(3,'            Impossible');
        EcrireMenu(4,'   Ce n''est pas une constructeur !');
        readln;
    end;
  end;

  ChangerProduction := ZONE;
end;

//Changement de production
//numeroZone : numéro de la zone
function AmeliorerBatimentZone(numeroZone : integer) : TLieu;
var
  positionSelectionne : integer;
  mouvement : TMouvementMenu;
  laZone : TZone;
begin

  //On récupère la zone
  laZone := GetZone(numeroZone);

  EffacerMenu();
  couleurTexte(Cyan);
  EcrireMenu(3,'  < Selectionnez un constructeur >');

  positionSelectionne := 0;
  mouvement := SelectionEmplacementClavier(laZone,positionSelectionne);

  if(mouvement = VALIDER)  then 
  begin
    if(laZone.emplacements[positionSelectionne].batiment.typeBatiment = AUCUNBAT) then
    begin
        EffacerMenu();
        couleurTexte(Red);
        EcrireMenu(3,'              Impossible');
        EcrireMenu(4,'       Ce n''est pas un bâtiment !');
        readln;
    end
    else if(laZone.emplacements[positionSelectionne].batiment.niveau = 0) then
    begin
        EffacerMenu();
        couleurTexte(Red);
        EcrireMenu(3,'              Impossible');
        EcrireMenu(4,'    Ce bâtiment ne s''améliore pas !');
        readln;
    end
    else if(laZone.emplacements[positionSelectionne].batiment.niveau = 3) then
    begin
        EffacerMenu();
        couleurTexte(Red);
        EcrireMenu(3,'              Impossible');
        EcrireMenu(4,'  Ce bâtiment est amélioré au maximum !');
        readln;
    end
    else 
    begin
      if AmeliorerBatiment(numeroZone,positionSelectionne) then
      begin
      EffacerMenu();
        couleurTexte(Green);
        EcrireMenu(3,'       Amélioration réussie !');
        readln;
      end
      else
      begin
        EffacerMenu();
        couleurTexte(Red);
        EcrireMenu(3,'  Impossible d''améliorer ce bâtiment');
        EcrireMenu(4,'    Il vous manque des ressources');
        readln;
      end;
    end;
  end;

  AmeliorerBatimentZone := ZONE;
end;
 
//Fait choisir la production de l'usine
//numeroZone : numero de la zone
//numeroEmplacement : numero de l'emplacement
procedure ChoixProductionConstructeur(numeroZone : integer; numeroEmplacement : integer);
var 
  choix : integer;
  i : integer;
  indiceMin : integer;
  indiceMax : integer;
  ressourceChoisie : TRessource;
  numeroPage : integer;
  nombrePage : integer;
const
  NOMBREAFFICHEPARPAGE = 5;
begin
  numeroPage := 0;
  ressourceChoisie := AUCUNRES;
  nombrePage := (Ord(High(TRessource))-IndicePremiereProduction()+1) div NOMBREAFFICHEPARPAGE;
  if((Ord(High(TRessource))-IndicePremiereProduction()+1) mod NOMBREAFFICHEPARPAGE > 0) then nombrePage:=nombrePage+1;

  while (ressourceChoisie = AUCUNRES) do
  begin
    EffacerMenu();
    EcrireMenu(0,'Que doit produire le constructeur ?');

    indiceMin := IndicePremiereProduction() + NOMBREAFFICHEPARPAGE*numeroPage;
    indiceMax := min(Ord(High(TRessource)),indiceMin+NOMBREAFFICHEPARPAGE-1);

    for i:= 1 to indiceMax-indiceMin+1 do 
      EcrireMenu(i,'  '+IntToStr(i)+'/ '+ToStringRessource(TRessource(indiceMin+i-1)));
    EcrireMenu(i+1,'  '+IntToStr(i+1)+'/ Autres');

    choix := -1;
    while(choix = -1) do
    begin
      ZoneReponse();
      choix := NormalisationChoix(1,i+1);
    end; 

    case choix=(i+1) of
      //Passage à la page suivante
      true : numeroPage := (numeroPage+1) mod nombrePage;
      //Choix d'une ressource
      else ressourceChoisie := TRessource(TRessource(indiceMin+choix-1));
    end;
  end;

  SetProduction(numeroZone,numeroEmplacement,ressourceChoisie);
end; 
end.