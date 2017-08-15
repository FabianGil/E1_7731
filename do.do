**ASIGNO MI DIRECTORIO DE TRABAJO 
cd C:\Computacion
/**TRABAJANDO CON LA BASE DE DATOS Base1.xls **/
*******************************************************************************************************************************************************************
**Importo mi base de datos ****************
 import excel "Base1.xls", sheet("base1") firstrow clear
 ** LIMPIO MI BASE DE DATOS **
 /* Renombro las variables */
   rename (var1) (Patient’sidentification)
   rename (var2) (Patientsex)
   rename (var3) (Chestpaintype)
   rename (var4) (Systolicbloodpressure)
   rename (var5) (Serumcholestoral)
   rename (var6) (Restingelectrocardiographic)
   rename (var6) (Restingelectrocardiographic)
   rename (var7) (Dateofbirth)
 describe //* Me doy cuenta del formato de las variables  la variable Systolicblood~e tiene formato str3  
 duplicates tag, generate (dup) //*me permite identificar los registros duplicados en terminos de todas las variables y generar un listado de los registros duplicados //*
 tabulate Patientssex, missing
 tabulate  Chestpaintype , missing
 // convertimos las  variables alfanumericas a numericas convirtiendo en valores faltantes los no numericos 
 
 destring Systolicbloodpressure, generate(sys) force  /* la nueva variable la llamamos sys */
 destring  Serumcholestoral , generate(coles) force   /* la nueva variable la llamamos coles */
 //* Exploramos las variable Dateofbirth*/
 codebook Dateofbirth /* podemos observar que es una variable tipo string (str10)
 // convertimos de string al formato date MDY  en la nueva variable Dateb */
 generate Dateb  = date( Dateofbirth , "MDY")
 format  Dateb %td
 
 //* SALVAMOS LA PRIMERA BASE DE DATOS *//
  save " base1.dta"
  
  **TRABAJANDO CON LA BASE DE DATOS Base2.csv **/
  ***************************************************************************************************************************************************************
  **Importo mi base de datos ****************
   import delimited "Base2.csv", delimiter(comma) clear 
   rename (var1) (Patient’sidentification)
   rename (var2) (Patientsex)
   rename (var3) (Chestpaintype)
   rename (var4) (Systolicbloodpressure)
   rename (var5) (Serumcholestoral)
   rename (var6) (Restingelectrocardiographic)
   rename (var7) (Dateofbirth)
   
   //* caracteristicas delas variables, formato , valores missing *//
   
   codebook
   duplicates tag, generate (dup) /* no registros duplicados */
   destring Systolicbloodpressure, generate(sys) force  /* la nueva variable la llamamos sys */
   destring  Serumcholestoral , generate(coles) force   /* la nueva variable la llamamos coles */
   generate Dateb  = date( Dateofbirth , "MDY")
   format  Dateb %td
   /* SALVAMOS LA SEGUNDA BASE  DE DATOS *//
  save "base2.dta"
  
   **TRABAJANDO CON LA BASE DE DATOS Base3.dta **/
  ***************************************************************************************************************************************************************
  **Importo mi base de datos ****************
  
  use "base3.dta"
  
   rename ( var1) (Patient’sidentification)
   rename ( var8) (angiographicdiseasestatus)
   rename ( var9) (Coronaryangiographydate)
   // convertimos de string al formato date MDY  en la nueva variable Datecoronary */
   generate Datecoronary  = date( Coronaryangiographydate , "DMY")
   format Datecoronary %td
 /* SALVAMOS LA TERCERA  BASE  DE DATOS *//
  save "base3.dta", replace
 //***PUNTO 1 ***// 
  /* Appending: Appending datasets ADICION DE LAS BASES DE DATOS 1 Y 2 */
/*********************************************************************************************************************************************/
  
  use  base1
  use  base2
  clear
  append using base1 base2
  save "base1_2.dta"
  
  
  /*************************************************************************************/
   /*MERGE : INTEGRAR INFORMACION DE BASES DE DATOS **** Adicionar la informacion contenida en la base3 a la base1_2*/
  
 use base3
 use base1_2
 merge 1:1 Patientsidentification using base3

 save "base1_2_3.dta" /* SE CREO   LA  base1_2_3.dta */
 //*PUNTO 2 
 /* Asigne nombres a las variables en la base de datos y rótulos a las variables en la base de datos.*/
 /* Asigne nombres a las variables en la base de datos y rótulos a las variables en la base de datos.*/
 label var Patientsidentification  "Id number"
 label var Patientsex "1 = male; 0 = female"
 label variable Chestpaintype "Dolor toraccico"
 label var sys " Presion Sistolica en mmHg"
 label var coles "Colesterol en mg/dl"
 label var Restingelectrocardiographic "0 = normal; 1 = having ST-T wave abnormality; 2 = showing probable or definite left ventricular hypertrophy"
 label var Dateofbirth "Fecha Nacimiento mm/dd/yyyy"
 label var Dateb "Fecha Nacimiento mm/dd/yyyy"
 label var angiographicdiseasestatus "0 = < 50% diameter narrowing; 1 = > 50% diameter narrowing"
 label var Datecoronary "Fecha angiografia dd/mm/yyyy"
 
 /** PUNTO 3  Rótulos para las variables categóricas  */
 label define Patientsex 1 "male" 0 "female"  
 label value Patientsex Patientsex
 label define Chestpaintype 1 "typical angina" 2 "atypical angina" 3 "on-anginal pain" 4 "Aasymptomatic"
 label value Chestpaintype Chestpaintype 
 label define Restingelectrocardiographic 0 "normal" 1 "having ST-T wave abnormality"  2 "showing probable or definite left ventricular hypertrophy" 
 label value Restingelectrocardiographic  Restingelectrocardiographic 
 label define angiographicdiseasestatus 0 " = < 50% diameter narrowing" 1 "= > 50% diameter narrowing"  
 label value angiographicdiseasestatus  angiographicdiseasestatus 

 /* DEJO SOLO LAS VARIABLES DEL ANALISIS  **//
 drop Systolicbloodpressure
 drop Serumcholestoral
 drop Dateofbirth
 drop Coronaryangiographydate
 /* RENOMBRO LAS VARIABLES TRASFORMADAS CON SU ETIQUETA ORIGINAL  **//
 rename sys Systolicbloodpressure
 rename coles Serumcholestoral
 rename Dateb Dateofbirth
 rename Datecoronary Coronaryangiographydate
 
 /*PUNTO 4 Categorice la presión arterial sistólica en las categorías  ****CATEGORIZACION DE LA PRESION ARTERIAL SISTOLICA *///
 
clonevar SystolicbloodpressureC = Systolicbloodpressure
recode SystolicbloodpressureC (1/89 =1) (90/119 = 2) (120/139=3) (140/159=4) (160/179=5) (180/max =6)

//*TOTULO PARA LA PRESION SISTOLICA *//
 label define SystolicbloodpressureC  1 "Hypotension" 2 "Desired"  3 "Prehypertesion" 4 "Stage 1 Hypertesion" 5 "Stage 2 Hypertesion" 6 "Hypertensive urgency"
 label value SystolicbloodpressureC  SystolicbloodpressureC 
 
  //* PUNTO 5 Genere una variable que contenga la edad de los pacientes al momento de la angiografía coronaria. **//
  

format %9.0g Dateofbirth
format %9.0g Coronaryangiographydate
generate edad_cateterismo = (Coronaryangiographydate- Dateofbirth)/ 365.25

 //* PUNTO 6 Describa los pacientes del estudio de acuerdo a la edad y sexo. **//
 summarize edad_cateterismo, detail
 graph box edad_cateterismo, by(Patientsex)
 
 //* PUNTO 7  Describa el diagnóstico de enfermedad coronaria  de acuerdo al tipo de dolor torácico presentado  , //

 tabulate Chestpaintype angiographicdiseasestatus, cchi2 chi2 column