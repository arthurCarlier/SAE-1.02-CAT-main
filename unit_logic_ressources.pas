//Unité en charge des ressources
unit Unit_Logic_Ressources;
{$codepage utf8}  
{$mode objfpc}{$H+}

interface
type
  TMateriau = (AUCUNMAT,FERMAT,CUIVREMAT,CALCAIREMAT,CHARBONMAT);                     //Materiau pour les gisements
  TRessource = (AUCUNRES,CUIVRE,FER,CALCAIRE,CHARBON,LINGOTCUIVRE,LINGOTFER,CABLE,PLAQUEFER,TUYAUFER,BETON,ACIER,PLAQUER,POUTRE,FONDATION);            //Différentes ressources
  
  TInventaire = array[TRessource] of integer;       //Inventaire de ressource

//Affichage d'une ressource sous forme d'une chaine de caractères
function ToStringRessource(ressource : TRessource) : string;

//Affichage d'un materiau sous forme d'une chaine de caractères
function ToStringMateriau(materiau : TMateriau) : string;

//Création d'un invenataire vide
function CreerInventaireVide() : TInventaire;

//Ajoute un inventaire à un autre
//inventaire : Inventaire à modifier
//inventaireAAjouter : Inventaire à ajouter
procedure AjouterInventaire(var inventaire : TInventaire; inventaireAAjouter : TInventaire);

//Retire un inventaire à un autre
//inventaire : Inventaire à modifier
//inventaireARetirer : Inventaire à retirer
procedure RetirerInventaire(var inventaire : TInventaire; inventaireARetirer : TInventaire);

//Test si un inventaire en contient un autre
//inventaire : Inventaire à modifier
//inventaireAContenir : Inventaire qui doit être contenu
function ContientInventaire(inventaire : TInventaire; inventaireAContenir : TInventaire) : boolean;

//Copie un inventaire dans un autre
//inventaireCible : inventaire modifié
//inventaireOrigine : inventaire modèle
procedure CopierInventaire(var inventaireCible : TInventaire; inventaireOrigine : TInventaire);

//Renvoie l'indice dans l'énumération du premier élément produit par les constructeurs
function IndicePremiereProduction() : integer;

//Cout de fabrication d'un lot de ressrouces
//Ressource produite
//Renvoie l'inventaire du coût
function CoutFabrication(ressource : TRessource) : TInventaire;

//Quantité produite de la ressource en fonction du niveau du batiement
function QuantiteProduite(ressource : TRessource; niveauBatiment : integer) : integer;

//String d'affichage d'un inventaire
function ToStringInventaire(inventaire : TInventaire) : string;

implementation
uses 
  sysutils;


//Renvoie l'indice dans l'énumération du premier élément produit par les constructeurs
function IndicePremiereProduction() : integer;
begin
  IndicePremiereProduction := 5;
end;

//Affichage d'un materiau sous forme d'une chaine de caractères
function ToStringMateriau(materiau : TMateriau) : string;
begin
  case materiau of
    AUCUNMAT : ToStringMateriau := 'Aucun';
    FERMAT :  ToStringMateriau := 'Fer';
    CUIVREMAT : ToStringMateriau := 'Cuivre';
    CALCAIREMAT : ToStringMateriau := 'Calcaire';
    CHARBONMAT : ToStringMateriau := 'Charbon';
  end;
end;

//Affichage d'une ressource sous forme d'une chaine de caractères
function ToStringRessource(ressource : TRessource) : string;
begin
  case ressource of
    AUCUNRES : ToStringRessource := 'Aucune';
    CUIVRE : ToStringRessource := 'Minerai de cuivre';
    FER : ToStringRessource := 'Minerai de fer';
    CALCAIRE : ToStringRessource := 'Calcaire';
    CHARBON : ToStringRessource := 'Charbon';
    LINGOTCUIVRE : ToStringRessource := 'Lingots de cuivre';
    LINGOTFER : ToStringRessource := 'Lingots de fer';
    CABLE : ToStringRessource := 'Cables de cuivre';
    PLAQUEFER : ToStringRessource := 'Plaques de fer';
    TUYAUFER : ToStringRessource := 'Tuyaux en fer';
    BETON : ToStringRessource := 'Sacs de Béton'; 
    ACIER : ToStringRessource := 'Acier';
    PLAQUER : ToStringRessource := 'Plaques renforcées';
    POUTRE : ToStringRessource := 'Poutres industrielles';
    FONDATION : ToStringRessource := 'Fondations';
  end;
end;

//String d'affichage d'un inventaire
function ToStringInventaire(inventaire : TInventaire) : string;
var 
  res : TRessource;
begin
  ToStringInventaire := '';
  for res := low(TRessource) to High(TRessource) do
  begin
    if(inventaire[res] > 0) then
    begin
      if Length(ToStringInventaire) > 0 then ToStringInventaire += ' / ';
      ToStringInventaire += ToStringRessource(res)+' (x'+IntToStr(inventaire[res])+')';
    end;
  end;
end;

//Cout de fabrication d'un lot de ressrouces
//Ressource produite
//Renvoie l'inventaire du coût
function CoutFabrication(ressource : TRessource) : TInventaire;
begin
  CoutFabrication := CreerInventaireVide();
  case ressource of 
    LINGOTCUIVRE : CoutFabrication[Cuivre] := 30;
    LINGOTFER : CoutFabrication[Fer] := 30;
    CABLE : CoutFabrication[LINGOTCUIVRE] := 15;
    PLAQUEFER : CoutFabrication[LINGOTFER] := 60;
    TUYAUFER : CoutFabrication[LINGOTFER] := 30;
    BETON : CoutFabrication[CALCAIRE] := 15;
    ACIER : 
      begin
        CoutFabrication[Fer] := 30;
        CoutFabrication[Charbon] := 15;
      end;
    PLAQUER : 
      begin
        CoutFabrication[PLAQUEFER] := 20;
        CoutFabrication[Acier] := 20;
      end;
    POUTRE : 
      begin
        CoutFabrication[PLAQUEFER] := 20;
        CoutFabrication[BETON] := 15;
      end;
    FONDATION : CoutFabrication[BETON] := 30;
  end;
end;

//Quantité produite de la ressource en fonction du niveau du batiement
function QuantiteProduite(ressource : TRessource; niveauBatiment : integer) : integer;
begin
  QuantiteProduite := 0;
  case ressource of 
    LINGOTCUIVRE : QuantiteProduite := 15;
    LINGOTFER : QuantiteProduite := 15;
    CABLE : QuantiteProduite := 5;
    PLAQUEFER : QuantiteProduite := 10;
    TUYAUFER : QuantiteProduite := 10;
    BETON : QuantiteProduite := 5;
    ACIER : QuantiteProduite := 15;
    PLAQUER : QuantiteProduite := 2;
    POUTRE : QuantiteProduite := 2;
    FONDATION : QuantiteProduite := 2;
  end;
  
  case niveauBatiment of
    2 : QuantiteProduite := (QuantiteProduite*3)div 2;
    3 : QuantiteProduite := QuantiteProduite*2;
  end;
end;

//Création d'un invenataire vide
function CreerInventaireVide() : TInventaire;
var
  res : TRessource;
begin
  for res := Low(TRessource) to High(TRessource) do CreerInventaireVide[res] := 0;
end;


//Ajoute un inventaire à un autre
//inventaire : Inventaire à modifier
//inventaireAAjouter : Inventaire à ajouter
procedure AjouterInventaire(var inventaire : TInventaire; inventaireAAjouter : TInventaire);
var
  res : TRessource;
begin
  for res := Low(TRessource) to High(TRessource) do
  begin
    inventaire[res] += inventaireAAjouter[res];
  end;
end;

//Retire un inventaire à un autre
//inventaire : Inventaire à modifier
//inventaireARetirer : Inventaire à retirer
procedure RetirerInventaire(var inventaire : TInventaire; inventaireARetirer : TInventaire);
var
  res : TRessource;
begin
  for res := Low(TRessource) to High(TRessource) do
  begin
    inventaire[res] -= inventaireARetirer[res];
  end;
end;


//Test si un inventaire en contient un autre
//inventaire : Inventaire à modifier
//inventaireAContenir : Inventaire qui doit être contenu
function ContientInventaire(inventaire : TInventaire; inventaireAContenir : TInventaire) : boolean;
var
  res : TRessource;
begin
  ContientInventaire := true;
  for res := Low(TRessource) to High(TRessource) do
  begin
    if(inventaire[res] < inventaireAContenir[res]) then ContientInventaire := false;;
  end;
end;

//Copie un inventaire dans un autre
//inventaireCible : inventaire modifié
//inventaireOrigine : inventaire modèle
procedure CopierInventaire(var inventaireCible : TInventaire; inventaireOrigine : TInventaire);
var
  res : TRessource;
begin
  for res := Low(TRessource) to High(TRessource) do
  begin
    inventaireCible[res] := inventaireOrigine[res];
  end;
end;


end.

