//Unit contenant des outils généraux d'IHM
unit unit_ihm_outils;
{$codepage utf8}  
{$mode objfpc}{$H+}

interface

Type
  TMouvementMenu = (AUTRE,VALIDER,FIN,HAUT,BAS,GAUCHE,DROIT);

//Dessine les cadres principaux de l'IHM
procedure DessinerCadresPrincipaux();

//Ecrit le texte donné centré sur la position donné
//ligne, colonne : position du centre du texte
//texte : texte à afficher
procedure EcrireCentreSur(colonne : integer; ligne : integer; texte : string);
 
//Ecrit un ligne pour la zone de menu
//ligne : numéro de la ligne du menu
//texte : texte à afficher  
procedure EcrireMenu(ligne : integer;texte : string);

//Ecrit un ligne pour la zone de Gauche
//ligne : numéro de la ligne du menu
//texte : texte à afficher  
procedure EcrireZoneGauche(colonne : integer;ligne : integer; texte : string);

//Efface la zone de menu
procedure EffacerMenu() ;

//Efface la zone de droite
procedure EffacerZoneDroite() ;
  
//Lit le clavier jusqu'à la pression d'une flèche, esc ou enter
//Renvoie le mouvement à faire
function LectureClavier() : TMouvementMenu;

//Dessine la zone de réponse utilisateur
procedure ZoneReponse();

implementation 
uses
  GestionEcran,Windows;
//Dessine les cadres principaux de l'IHM
procedure DessinerCadresPrincipaux();
begin 
  couleurTexte(White);
  couleurFond(Black);
  //Cadre extérieur
  dessinerCadreXY(0,0,199,39,simple,White,Black);
  //Cadre gauche
  dessinerCadreXY(0,0,50,39,simple,White,Black);
  //Jonctions
  deplacerCurseurXY(50,0);write(#194);
  deplacerCurseurXY(50,39);write(#193);
end;


//Ecrit le texte donné centré sur la position donné
//ligne, colonne : position du centre du texte
//texte : texte à afficher
procedure EcrireCentreSur(colonne : integer; ligne : integer; texte : string);
var
  taille : integer; //Taille réelle de la chaîne (gestion de l'UTF8)
begin
  taille := Length(UTF8Decode(texte));
  deplacerCurseurXY(colonne-(taille div 2)-(taille mod 2),ligne);
  write(texte);
end;
  
//Ecrit un ligne pour la zone de menu
//ligne : numéro de la ligne du menu
//texte : texte à afficher  
procedure EcrireMenu(ligne : integer;texte : string);
begin
  deplacerCurseurXY(5,27+ligne);write(texte);
end;

//Dessine la zone de réponse utilisateur
procedure ZoneReponse();
begin
  dessinerCadreXY(40,36,49,38,simple,White,Black);
  deplacerCurseurXY(44,37);
end;

//Ecrit un ligne pour la zone de Gauche
//ligne : numéro de la ligne du menu
//colonne : numéro de la colonne du menu
//texte : texte à afficher  
procedure EcrireZoneGauche(colonne : integer;ligne : integer; texte : string);
begin
  deplacerCurseurXY(5+colonne,5+ligne);write(texte);
end;

//Efface la zone de menu
procedure EffacerMenu();
begin
  dessinerCadreXY(1,27,49,38,simple,Black,Black);
  CouleurTexte(White);
end;

//Efface la zone de droite
procedure EffacerZoneDroite() ;
begin
  dessinerCadreXY(51,1,198,38,simple,Black,Black);
  CouleurTexte(White);
end;

//Lit le clavier jusqu'à la pression d'une flèche, esc ou enter
//Renvoie le mouvement à faire
function LectureClavier() : TMouvementMenu;
var
  hIn: THandle;
  rec: TInputRecord;
  count: DWORD;
begin
  hIn := GetStdHandle(STD_INPUT_HANDLE);
  ReadConsoleInput(hIn, rec, 1, count);
  while (rec.EventType <> KEY_EVENT) or not(rec.Event.KeyEvent.bKeyDown) do ReadConsoleInput(hIn, rec, 1, count);
   
  case rec.Event.KeyEvent.wVirtualKeyCode of
    VK_UP:    LectureClavier := HAUT;
    VK_DOWN:  LectureClavier := BAS;
    VK_LEFT:  LectureClavier := GAUCHE;
    VK_RIGHT: LectureClavier := DROIT;
    VK_ESCAPE: LectureClavier := FIN;
    VK_RETURN: LectureClavier := VALIDER;
    else LectureClavier := AUTRE;
  end;
    
end;

end.