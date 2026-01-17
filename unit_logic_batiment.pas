//Unité en charge des batiments
unit Unit_Logic_Batiment;
{$codepage utf8}  
{$mode objfpc}{$H+}

interface
uses Unit_Logic_Ressources,math;

type
    TTypeBatiment = (AUCUNBAT,MINE,CONSTRUCTEUR,HUB,CENTRALE,ASCENSEUR);        //Différents types de batiments
    TBatiment = record
        typeBatiment : TTypeBatiment;                           //type de batiment
        production : TRessource;                                //production du batiment
        niveau : integer;                                       //niveau du batiment
    end;

//Création d'un batiment
//typeBatiment : type du batiment
//production : que produit le batiment
//niveau : niveau du batiment
function CreerBatiment(typeBatiment : TTypeBatiment; production : TRessource; niveau : integer) : TBatiment;

//Renvoie la chaine à afficher en fonction du type de bâtiment
function ToStringBatiment(typeBatiment : TTypeBatiment) : string;

//Renvoie la production d'un batiement donnée
//batiment : le batiement
//niveauGisement : le niveau du gisement (pour les mines)
function ProductionBatiment(batiment : TBatiment; niveauGisement : integer) : TInventaire;

//Renvoie les ressources nécessaire pour la production d'un batiement
//batiment : le batiement
function CoutProductionBatiment(batiment : TBatiment) : TInventaire;

//Renvoie le cout de construction d'un batiment
//batiment : batiment à construire
function CoutConstruction(batiment : TBatiment) : TInventaire;

//Renvoie le cout de l'amélioration d'un batiment
//batiment : le batiment à améliorer
function CoutAmelioration(batiment : TBatiment) : TInventaire;

//Consommation électrique d'un batiment
//batiment : le batiment;
function ConsommationElectriciteBatiment(batiment : TBatiment) : integer;

implementation

//Renvoie la chaine à afficher en fonction du type de bâtiment
function ToStringBatiment(typeBatiment : TTypeBatiment) : string;
begin
  case typeBatiment of
    AUCUNBAT : ToStringBatiment := 'Aucun';
    MINE : ToStringBatiment := 'Mine Mk.';
    CONSTRUCTEUR : ToStringBatiment := 'Constructeur';
    HUB : ToStringBatiment := 'HUB';
    CENTRALE :ToStringBatiment := 'Centrale électrique';
    ASCENSEUR : ToStringBatiment := 'Ascenseur orbital';
  end;
end;

//Création d'un batiment
//typeBatiment : type du batiment
//production : que produit le batiment
//niveau : niveau du batiment
function CreerBatiment(typeBatiment : TTypeBatiment; production : TRessource; niveau : integer): TBatiment;
begin
  CreerBatiment.typeBatiment := typeBatiment;
  CreerBatiment.production := production;
  CreerBatiment.niveau := niveau;
end;

//Renvoie la production d'un batiement donnée
//batiment : le batiement
//niveauGisement : le niveau du gisement (pour les mines)
function ProductionBatiment(batiment : TBatiment; niveauGisement : integer) : TInventaire;
begin
  ProductionBatiment := CreerInventaireVide();
  case batiment.typeBatiment of
    Mine : ProductionBatiment[batiment.production] := Round(30*IntPower(2,batiment.niveau-1)*IntPower(2,niveauGisement-1));
    Constructeur : ProductionBatiment[batiment.production] := QuantiteProduite(batiment.production,batiment.niveau);
  end;
end;

//Renvoie les ressources nécessaire pour la production d'un batiment
//batiment : le batiment
function CoutProductionBatiment(batiment : TBatiment) : TInventaire;
begin
  CoutProductionBatiment := CreerInventaireVide();
  case batiment.typeBatiment of
    Constructeur : CoutProductionBatiment := CoutFabrication(batiment.production);
  end;
end;


//Renvoie le cout de construction d'un batiment
//batiment : batiment à construire
function CoutConstruction(batiment : TBatiment) : TInventaire;
begin
  CoutConstruction := CreerInventaireVide();
  case batiment.typeBatiment of
    Mine : CoutConstruction[PLAQUEFER] := 10;
    Constructeur :
    begin
      CoutConstruction[PLAQUEFER] := 10;
      CoutConstruction[CABLE] := 10;
    end;
    CENTRALE :
    begin
      CoutConstruction[PLAQUEFER] := 10;
      CoutConstruction[BETON] := 20;
      CoutConstruction[CABLE] := 30;
    end;
    ASCENSEUR : 
    begin
      CoutConstruction[PLAQUEFER] := 200;
      CoutConstruction[BETON] := 200;
      CoutConstruction[CABLE] := 200;
    end;
  end;
end;

//Renvoie le cout de l'amélioration d'un batiment
//batiment : le batiment à améliorer
function CoutAmelioration(batiment : TBatiment) : TInventaire;
begin
  CoutAmelioration := CreerInventaireVide();
  case batiment.typeBatiment of
    Mine : 
    case batiment.niveau of
      1: 
      begin
        CoutAmelioration[BETON] := 20;
        CoutAmelioration[PLAQUEFER] := 20;
      end;
      2: 
      begin
        CoutAmelioration[ACIER] := 20;
        CoutAmelioration[PLAQUEFER] := 20;
      end;
    end;
    Constructeur :
    case batiment.niveau of
      1: 
      begin
        CoutAmelioration[BETON] := 20;
        CoutAmelioration[PLAQUEFER] := 20;
      end;
      2: 
      begin
        CoutAmelioration[ACIER] := 20;
        CoutAmelioration[PLAQUEFER] := 20;
      end;
    end;
  end;
end;

//Consommation électrique d'un batiment
//batiment : le batiment;
function ConsommationElectriciteBatiment(batiment : TBatiment) : integer;
begin
  ConsommationElectriciteBatiment := 0;
  case batiment.typeBatiment of
    Mine : ConsommationElectriciteBatiment := 100+100*(batiment.niveau-1);
    Constructeur : ConsommationElectriciteBatiment := 200+100*(batiment.niveau-1);
    Hub : ConsommationElectriciteBatiment := 100;
    Ascenseur : ConsommationElectriciteBatiment := 1000;
  end;
end;

end.

