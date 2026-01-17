unit unit_logic_temps;
{$codepage utf8}  
{$mode objfpc}{$H+}

interface

  //Initialise la date
  procedure InitialisationDate();

  //Passe au jour suivant dans la date actuelle
  procedure PasserJourDate();

  //Affichage de la date en string
  function AffichageDate() : string;
  
implementation
uses
  sysutils;
type
  TJour = (Lundi,Mardi,Mercredi,Jeudi,Vendredi,Samedi,Dimanche);
  TMois = (Janvier,Fevrier,Mars,Avril,Mai,Juin,Juillet,Aout,Septembre,Octobre,Novembre,Decembre);  
  TDate = record
    jour : TJour;
    numero : integer;
    mois : TMois;
    annee : integer;
  end;

var
  dateActuelle : TDate;  

  //Initialise la date
  procedure InitialisationDate();
  begin
    dateActuelle.annee := 2025;
    dateActuelle.numero := 24;
    dateActuelle.mois := Avril;
    dateActuelle.jour := Jeudi;
  end;

  //Renvoie le jour suivant
  function JourSuivant(jour : TJour) : TJour;
  begin
    if(jour = Dimanche) then JourSuivant := Lundi
    else JourSuivant := succ(jour);
  end;
  
  //Renvoie le mois suivant
  function MoisSuivant(mois : TMois) : TMois;
  begin
    if(mois = Decembre) then MoisSuivant := Janvier
    else MoisSuivant := succ(mois);
  end;

  //L'année est-elle bissextile
  function EstBissextile(annee : integer) : boolean;
  begin
    EstBissextile := (((annee mod 4 = 0) AND (annee mod 100 <> 0)) OR (annee mod 400 = 0));
  end;

  //Nombre de jour du mois
  function NombreJoursMois(mois : TMois; annee : integer) : integer;
  begin
    case mois of
      Janvier,Mars,Mai,Juillet,Aout,Octobre,Decembre : NombreJoursMois:=31;
      Fevrier :
      begin
        if(EstBissextile(annee)) then NombreJoursMois := 29
        else NombreJoursMois := 28;
      end; 
      else NombreJoursMois := 30;
    end;
  end;

  //Passe au jour suivant dans la date actuelle
  procedure PasserJourDate();
  begin
    dateActuelle.jour := JourSuivant(dateActuelle.jour);
    dateActuelle.numero += 1;

    if(dateActuelle.numero > NombreJoursMois(dateActuelle.mois,dateActuelle.annee)) then
    begin
      dateActuelle.numero := 1;
      dateActuelle.mois := MoisSuivant(dateActuelle.mois);
      if(dateActuelle.mois = Janvier) then dateActuelle.annee += 1;
    end;
  end;

  //Affichage de la date en string
  function AffichageDate() : string;
  begin
    AffichageDate := '';
    case dateActuelle.jour of
      Lundi : AffichageDate += 'Lundi';
      Mardi : AffichageDate += 'Mardi';
      Mercredi : AffichageDate += 'Mercredi';
      Jeudi : AffichageDate += 'Jeudi';
      Vendredi : AffichageDate += 'Vendredi';
      Samedi : AffichageDate += 'Samedi';
      Dimanche : AffichageDate += 'Dimanche';
    end;
    AffichageDate += ' '+IntToStr(dateActuelle.numero)+' ';
    case dateActuelle.mois of
      Janvier: AffichageDate += 'Janvier';
      Fevrier: AffichageDate += 'Févirer';
      Mars: AffichageDate += 'Mars';
      Avril: AffichageDate += 'Avril';
      Mai: AffichageDate += 'Mai';
      Juin: AffichageDate += 'Juin';
      Juillet: AffichageDate += 'Juillet';
      Aout: AffichageDate += 'Août';
      Septembre: AffichageDate += 'Septembre';
      Octobre: AffichageDate += 'Octobre';
      Novembre: AffichageDate += 'Novembre';
      Decembre: AffichageDate += 'Décembre';
    end;
    AffichageDate += ' '+IntToStr(dateActuelle.annee);
  end;
end.