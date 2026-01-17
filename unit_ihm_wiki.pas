//Unité de charge de l'affichage du wiki
unit unit_ihm_wiki;
{$codepage utf8}  
{$mode objfpc}{$H+}

interface
  uses unit_logic_lieu;
  //Ecran Principal du Wiki 
  //Renvoie le prochaine lieu
  function EcranWiki() : TLieu;

implementation
uses
  SysUtils,GestionEcran,unit_ihm_outils,unit_logic_outils,unit_logic_batiment,unit_logic_ressources;
  

  procedure AfficherBatiments();
  var
    bat : TTypeBatiment;
    ligne : integer;
    batiment : TBatiment;
  const
    colonne = 65;
  begin
    EffacerZoneDroite();
    ligne := 5;
    for bat := Low(TTypeBatiment) to High(TTypeBatiment) do
    begin
      if(bat <> AUCUNBAT) then
      begin
        deplacerCurseurXY(colonne,ligne); write(ToStringBatiment(bat));
        ligne+=1;
        batiment := CreerBatiment(bat,AUCUNRES,1);

        if(bat <> HUB) then
        begin
          deplacerCurseurXY(colonne+3,ligne);write('- Coût de construction : '+ToStringInventaire(CoutConstruction(batiment)));
          ligne+=1;
        end;

        if(bat <> CENTRALE) then
        begin
          deplacerCurseurXY(colonne+3,ligne);write('- Energie consommée : '+IntToStr(ConsommationElectriciteBatiment(batiment)));
        end
        else 
        begin
          deplacerCurseurXY(colonne+3,ligne);write('- Energie produite : 1200');
        end;
        ligne+=1;

        if(bat = Mine) OR (bat = CONSTRUCTEUR) then
        begin
          deplacerCurseurXY(colonne+3,ligne);write('- Coût d''amélioration niv 2 : '+ToStringInventaire(CoutAmelioration(batiment)));
          ligne+=1;
          batiment.niveau := 2;
          deplacerCurseurXY(colonne+3,ligne);write('- Coût d''amélioration niv 3 : '+ToStringInventaire(CoutAmelioration(batiment)));
          ligne+=1;
        end;
        ligne+=1;

      end;
    end;
  end;

  procedure AfficherRecettes();
  var
    i : integer;
    ligne : integer;
    colonne : integer;
  begin
    EffacerZoneDroite();
    ligne := 4;
    colonne := 55;
    for i := IndicePremiereProduction() to Ord(High(TRessource)) do
    begin
      deplacerCurseurXY(colonne,ligne); write(ToStringRessource(TRessource(i)));
      ligne += 1;
      deplacerCurseurXY(colonne+3,ligne); write('- Quantité produite par lot : '+IntToStr(QuantiteProduite(TRessource(i),1)));
      ligne += 1;
      deplacerCurseurXY(colonne+3,ligne); write('- Ressources nécessaires : '+ToStringInventaire(CoutFabrication(TRessource(i))));
      ligne += 3;
      if(ligne > 35) then 
      begin
        ligne := 4;
        colonne := 55+65;
      end;
    end;
  end;
  

  function MenuWiki() : integer;
  var
    choix : integer;
  begin
    EffacerMenu();
    EcrireMenu(0,'Que veux-tu faire ?');
    EcrireMenu(1,'  1/ Voir la liste des bâtiments');
    EcrireMenu(2,'  2/ Voir la liste des productions');
    EcrireMenu(3,'  3/ Quitter le wiki');
    
    choix := -1;
    while(choix = -1) do
    begin
      ZoneReponse();
      choix := NormalisationChoix(1,3);
    end;

    case choix of
      1: AfficherBatiments();
      2: AfficherRecettes();
    end;

    MenuWiki := choix;
  end;

  //Ecran Principal du Wiki 
  //Renvoie le prochaine lieu
  function EcranWiki() : TLieu;
  var
    choix : integer;
  begin
    effacerEcran();
    DessinerCadresPrincipaux();

    choix := -1;
    while(choix <> 3) do choix := MenuWiki();

    EcranWiki := ZONE;
  end;
  
end.