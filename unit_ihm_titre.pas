//Unité en charge de la gestion de l'écran titre et du menu principal
unit Unit_IHM_Titre;
{$codepage utf8}  
{$mode objfpc}{$H+}

interface
uses
  Unit_Logic_Lieu;

//Fonction affichant l'écran titre
//Renvoie le prochain lieu
function EcranTitre() : TLieu;

//Fonction affichant l'écran du menu principal
//Renvoie le prochain lieu
function EcranMenu() : TLieu;

//Ecran d'affichage de l'histoire
//Renvoie le prochain lieu
function EcranHistoire() : TLieu;

implementation
uses
  Unit_Ihm_Outils,Unit_Logic_Outils,GestionEcran,SysUtils;

procedure AffichePixel(s:string ; ligne : integer);
var
  i:integer;
begin
  deplacerCurseurXY(51,ligne);
  for i := 1 to Length(s) do
  begin
    case s[i] of
      'H' : couleurFond(LightGray);
      'B' : couleurFond(DarkGray);
      else couleurFond(Black);
    end;
    write(' ');
  end;
end;

procedure AfficherLogo();
begin
AffichePixel('        HHHHHHHHHHH                                        HHHHHHHHHH                           ',0);
AffichePixel('        HHHHHHHHHH                                          HHHHHHHHHH                          ',1);
AffichePixel('        HHHHHHHH                                              HHHHHHHH                          ',2);
AffichePixel('        HHHHHHHHHH                                             HHHHHHHH                         ',3);
AffichePixel('          HHHHHHHHHH                                          HHHHHHHHHH                        ',4);
AffichePixel('              HHHHHHH                                       BBBBBBBBBBBBBBBB                    ',5);
AffichePixel('                HHHHHH                                      BBGGBBGGGGBBGGBB                    ',6);
AffichePixel('              HHHHHHHH                                        BBBBBBBBBBBB                      ',7);
AffichePixel('              HHHHHHH                       BBBB              BBGGGGGGGGBB                      ',8);
AffichePixel('              HHHHHH                    BBBBGGGGBBBB          BBGGGGGGGGBB                      ',9);
AffichePixel('              BBBBBBBB              BBBBGGGGGGGGGGGGBBBB      BBGGGGGGGGBB                      ',10);
AffichePixel('              BBGGGGBB          BBBBGGGGGGGGGGGGGGGGGGGGBBBB  BBGGGGGGGGBB                      ',11);
AffichePixel('              BBGGGGBB      BBBBGGGGGGGGGGGGGGGGGGGGGGGGGGGGBBBBGGGGGGGGBB                      ',12);
AffichePixel('              BBGGGGBB  BBBBGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBBBBGGGGBB                      ',13);
AffichePixel('              BBGGGGBBBBGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBBBBBB                      ',14);
AffichePixel('              BBBBBBGGGGGGGGBBBBBBBBGGBBBBBBGGGGGGGGGGGGGGBBBBBBGGGGGGGGBBBB                    ',15);
AffichePixel('            BBBBGGGGGGGGGGGGBBBBGGBBGGBBBBBBGGGGGGGGGGGGGGBBBBBBGGGGGGGGGGGGBBBB                ',16);
AffichePixel('        BBBBGGGGGGGGGGGGGGGGBBBBBBBBGGBBBBBBGGGGGGGGGGGGGGBBBBBBGGGGGGGGGGGGGGGGBBBB            ',17);
AffichePixel('    BBBBGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBBBB        ',18);   
AffichePixel('  BBBBGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBB        ',19);
AffichePixel('BBGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBB        ',20);
AffichePixel('BBGGGGGGGGGGGGGGBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBGGGGGGGGGGGGGGGGGGGGBB        ',21);
AffichePixel('BBGGGGGGGGGGGGBBGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBBGGGGGGGGGGGGGGGGGGBB        ',22);
AffichePixel('BBGGGGGGGGGGGGBBGGGGGGGGGGGGBBGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBBGGGGGGGGGGGGGGGGGGBB        ',23);
AffichePixel('BBGGGGGGGGGGGGBBGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBBGGGGGGGGGGGGGGBBBBBBBBBBBB  ',24);
AffichePixel('BBGGGGGGGGGGGGBBBBBBBBBBBBBBBBGGGGGGGGBBBBBBBBBBBBBBBBGGGGGGGGBBBBBBGGGGGGGGGGGGGGBBGGGGGGGGBB  ',25);
AffichePixel('BBGGGGGGGGGGGGBBGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBBGGGGGGGGGGGGGGBBGGGGGGGGBB  ',26);
AffichePixel('BBGGGGGGGGGGGGBBGGBBGGGGGGGGBBBBBBBBBBBBBBGGBBBBBBBBBBGGBBBBBBBBBBBBGGGGGGGGGGGGGGBBGGGGGGGGBB  ',27);
AffichePixel('BBGGGGGGGGGGGGBBGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBBGGGGGGGGGGGGGGBBGGGGGGGGBB  ',28);
AffichePixel('BBGGGGBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBGGGGGGGGGGGGBBGGGGGGGGGGGGGGBBGGGGGGGGBB  ',29);
AffichePixel('BBGGBBGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBBGGGGGGGGGGBBGGGGGGGGGGGGGGBBGGGGGGGGBB  ',30);
AffichePixel('BBGGBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBGGGGGGBBGGBBGGGGGGGGGGGGGGBBGGGGGGGGBB  ',31);
AffichePixel('BBGGGGGGGGGGBBGGGGBBGGBBGGGGGGGGBBGGBBGGGGGGGGGGGGBBBBGGGGGGGGGGGGBBGGGGGGGGBBBBBBBBBBBBBBBBBBBB',32);
AffichePixel('BBGGGGGGGGGGBBGGGGBBGGBBGGGGGGGGBBGGBBGGGGGGGGGGGGGGBBGGGGGGGGBBBBBBGGGGGGGGBBGGGGGGGGGGGGGGGGBB',33);
AffichePixel('BBGGGGGGGGGGBBGGGGBBGGBBGGGGGGGGBBGGBBGGGGGGGGGGGGGGBBBBBBBBBBBBBBBBBBBBBBBBBBGGGGGGGGGGGGGGGGBB',34);
AffichePixel('BBGGGGGGGGGGBBGGGGBBGGBBGGGGGGGGBBGGBBGGGGGGGGGGGGGGBBGGGGBBGGGGBBGGGGBBGGGGBBGGGGGGGGGGBBBBBBBB',35);
AffichePixel('BBGGGGGGGGGGBBGGGGBBGGBBGGGGGGGGBBGGBBGGGGGGGGGGGGGGBBGGGGBBGGGGBBGGGGBBGGGGBBGGGGGGGGGGBBBBBBBB',36);
AffichePixel('BBGGGGGGGGGGBBGGGGBBGGBBGGGGGGGGBBGGBBGGGGGGGGGGGGGGBBGGGGBBGGGGBBGGGGBBGGGGBBGGGGGGGGGGBBGGGGBB',37);
AffichePixel('BBGGGGGGGGGGBBGGGGBBGGBBGGGGGGGGBBGGBBGGGGGGGGGGGGGGBBGGGGBBGGGGBBGGGGBBGGGGBBGGGGGGGGGGBBGGGGBB',38);
AffichePixel('BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB',39);

end;
//Fonction affichant l'écran titre
//Renvoie le prochain lieu
function EcranTitre() : TLieu;
begin
effacerEcran();
AfficherLogo();
couleurFond(Black);
couleurTexte(6);
Sleep(500);
deplacerCurseurXY(0,9);                                                                                                                                                               
writeln('                   _________________________________________________________________________________________________________________________________________________________');
writeln('                  |\________________________________________________________________________________________________________________________________________________________\');
writeln('                  \|________________________________________________________________________________________________________________________________________________________|');
writeln();                                                                                                                                                                      
writeln();                                                                                                                                                                    
writeln('                              ________  ________  _________  ___  ________  ________ ________  ________ _________           ___          ___  ___  ___  _________                 ');
writeln('                             |\   ____\|\   __  \|\___   ___\\  \|\   ____\|\  _____\\   __  \|\   ____\\___   ___\        |\  \        |\  \|\  \|\  \|\___   ___\               ');
writeln('                             \ \  \___|\ \  \|\  \|___ \  \_\ \  \ \  \___|\ \  \__/\ \  \|\  \ \  \___\|___ \  \_|        \ \  \       \ \  \ \  \\\  \|___ \  \_|               ');
writeln('                              \ \  \___ \ \  \_\  \   \ \  \ \ \  \ \  \____\ \  \__ \ \  \_\  \ \  \       \ \  \          \ \  \       \ \  \ \  \\\  \   \ \  \                 ');
writeln('                               \ \_____  \ \   __  \   \ \  \ \ \  \ \_____  \ \   __\\ \   __  \ \  \       \ \  \          \|__|        \ \  \ \  \\\  \   \ \  \                ');
writeln('                                \|____|\  \ \  \ \  \   \ \  \ \ \  \|____|\  \ \  \_| \ \  \ \  \ \  \       \ \  \                       \ \  \ \  \\\  \   \ \  \               ');
writeln('                                      \ \  \ \  \ \  \   \ \  \ \ \  \    \ \  \ \  \   \ \  \ \  \ \  \_____  \ \  \                       \ \  \ \       \   \ \  \              ');
writeln('                                   ____\_\  \ \__\ \__\   \ \__\ \ \__\____\_\  \ \__\   \ \__\ \__\ \_______\  \ \__\                       \ \__\ \_______\   \ \__\              ');
writeln('                                  |\_________\|__|\|__|    \|__|  \|__|\_________\|__|    \|__|\|__|\|_______|   \|__|                        \|__|\|_______|    \|__|              ');
writeln('                                  \|_________|                        \|_________|                                                                                                  ');
writeln();                                                                                                                                                                      
writeln();                                                                                                                                                                     
writeln('                        _________________________________________________________________________________________________________________________________________________________');
writeln('                       |\________________________________________________________________________________________________________________________________________________________\');
writeln('                       \|________________________________________________________________________________________________________________________________________________________|');
deplacerCurseurXY(80,32);
writeln('< Appuyez sur une touche pour continuer >');
  readln;
  EcranTitre := MENU;
end;

//Fonction affichant l'écran du menu principal
//Renvoie le prochain lieu
function EcranMenu() : TLieu;
var
  choix : integer;
begin
  dessinerCadreXY(75,32,200-75,32+6,simple,White,Black);
  choix := -1;
  while(choix = -1) do
  begin
       deplacerCurseurXY(88,34);writeln('Menu principal');
       deplacerCurseurXY(88,35);writeln('1/ Commencer la partie');
       deplacerCurseurXY(88,36);writeln('2/ Quitter');
       choix := NormalisationChoix(1,2);

       case choix of
            1: EcranMenu:= HISTOIRE;
            2: EcranMenu:= QUITTER;
       end;
  end;

end;

function EcranHistoire() : TLieu;
begin
  effacerEcran();
  EcrireCentreSur(100,3,'Dans une réalité… pas si alternative que ça…');
  
  EcrireCentreSur(100,5,'2024 : une année particulièrement compliquée.');
  EcrireCentreSur(100,6,'Suite à un mouvement de grève encore jamais vu (les Gilets Verts) pas moins de douze gouvernements ');
  EcrireCentreSur(100,7,'se sont succédé entre janvier et mars. Oui, douze. En trois mois.');
  
  EcrireCentreSur(100,9,'L''instabilité économique provoquée par ces changements politiques incessants a plongé le pays dans');
  EcrireCentreSur(100,10,'une ère de chaos. Et ce qui devait arriver... arriva. Privée de toute subvention de l''État, la direc');
  EcrireCentreSur(100,11,'tion de l''IUT de Dijon a dû se rendre à l''évidence : à défaut d''avoir un budget, il allait falloir');
  EcrireCentreSur(100,12,'utiliser la seule ressource encore abondante et peu coûteuse... vous, les étudiant(e)s.');
  
  EcrireCentreSur(100,14,'Le 30 avril 2024, la direction dévoile alors une stratégie de redressement financier pour le moins');
  EcrireCentreSur(100,15,'novatrice : Envoyer les étudiant(e)s coloniser d''autres planètes et y construire des usines de pro');
  EcrireCentreSur(100,16,'duction automatisées. Un moyen simple (et étonnamment peu onéreux) d''obtenir rapidement les ressour');
  EcrireCentreSur(100,17,'ces nécessaires à la survie de l''établissement.');
  
  EcrireCentreSur(100,19,'C''est ainsi que, le 15 septembre 2024, vous embarquez pour un voyage à destination de Mars, à bord');
  EcrireCentreSur(100,20,'d''une fusée baptisée “Maëlle”, fièrement assemblée lors d''une SAE du département GMP. Avec pour');
  EcrireCentreSur(100,21,'seul(e)s compagnons la Lune, le ciel, et une check-list de sécurité rédigée par Franck Deher,');
  EcrireCentreSur(100,22,'vous atteignez (contre toute attente) la surface martienne sans le moindre incident majeur.');
  
  EcrireCentreSur(100,24,'Maintenant, il est temps de vous mettre au travail. L''IUT a besoin de vous !');
  
  EcrireCentreSur(100,32,'< Appuyez sur une touche pour continuer >');

  readln;

  EcranHistoire := INIT;
end;

end.

