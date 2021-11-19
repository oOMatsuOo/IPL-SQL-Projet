--CreateTable
DROP SCHEMA IF EXISTS projet CASCADE;
CREATE SCHEMA projet;
CREATE TABLE projet.etudiants (
  id_etudiant SERIAL PRIMARY KEY,
  nom CHARACTER VARYING (100) NOT NULL, CHECK (nom ~ '^[a-z -]+$'),
  prenom CHARACTER VARYING (50) NOT NULL, CHECK (prenom ~ '^[a-z -]+$'),
  email CHARACTER VARYING (150) NOT NULL UNIQUE , CHECK (email ~ '[a-zA-Z0-9+.-]+@[a-zA-Z0-9.-]+.[a-zA-Z0-9+.-]+ '), --'%_@__%.__%'
  mdp CHARACTER VARYING (50) NOT NULL, CHECK (mdp<>''),
  bloc INTEGER , CHECK (bloc > 0 AND bloc <= 3),
  nbr_credits_valides INTEGER NOT NULL DEFAULT 0, CHECK (nbr_credits_valides > 0 AND nbr_credits_valides <= 180)
);

CREATE TABLE projet.ues (
  id_ue SERIAL PRIMARY KEY,
  code_ue CHARACTER VARYING (100) NOT NULL UNIQUE , CHECK (code_ue SIMILAR TO '^[a-z ,.-]+$'),
  nom CHARACTER VARYING (100) NOT NULL, CHECK (nom SIMILAR TO '^BINV'|| bloc ||'+$'),
  bloc INTEGER NOT NULL , CHECK (bloc > 0 AND bloc < 4),
  nbr_credits INTEGER NOT NULL , CHECK (nbr_credits > 0 AND nbr_credits <60),
  nbr_inscrits INTEGER NOT NULL DEFAULT 0, CHECK (nbr_inscrits >= 0 )
);

CREATE TABLE projet.paes (
  code_pae SERIAL PRIMARY KEY,
  id_etudiant INTEGER NOT NULL REFERENCES projet.etudiants(id_etudiant),
  etat CHARACTER VARYING (8) NOT NULL , CHECK (etat LIKE 'en_cours'  OR etat LIKE 'valide' ),
  nbr_credits_totale INTEGER DEFAULT 0, CHECK (nbr_credits_totale >= 0 AND nbr_credits_totale <= 180)
);

CREATE TABLE projet.prerequis (
  id_ue INTEGER NOT NULL REFERENCES projet.ues(id_ue),
  id_ue_prerequis INTEGER NOT NULL REFERENCES projet.prerequis(id_ue),
  PRIMARY KEY (id_ue, id_ue_prerequis)
);

CREATE TABLE projet.ues_validees (
  id_etudiant INTEGER NOT NULL REFERENCES projet.etudiants(id_etudiant),
  id_ue INTEGER NOT NULL REFERENCES projet.ues(id_ue),
  PRIMARY KEY (id_etudiant, id_ue)
);

CREATE TABLE projet.ues_en_cours (
   code_pae INTEGER NOT NULL REFERENCES projet.paes(code_pae),
   id_ue INTEGER NOT NULL REFERENCES projet.ues(id_ue),
  PRIMARY KEY (code_pae,id_ue)
);

CREATE OR REPLACE FUNCTION projet.paeEtudiants()
RETURNS SETOF RECORD as $$
DECLARE
BEGIN

END;
$$ LANGUAGE plpgsql;

