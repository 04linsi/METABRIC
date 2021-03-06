## 
### ---------------
###
### Create: Jianming Zeng 
### Email: jmzeng1314@163.com
### Blog: http://www.bio-info-trainee.com/
### Forum:  http://www.biotrainee.com/thread-1376-1-1.html
### CAFS/SUSTC/Eli Lilly/University of Macau
### Update Log: 2018-08-10  First version
### Update Log: 2019-08-16  second version codes (R version 3.5.1 (2018-07-02))
###
### ---------------

rm(list = ls())
wkdir=getwd()
options(stringsAsFactors = F)
load(file=file.path(wkdir,'data','metabric_expression.Rdata'))
dim(expr)
expr[1:4,1:4]
load(file=file.path(wkdir,'data','metabric_clinical.Rdata'))
dim(clin)
clin[1:4,1:4]
clin$PATIENT_ID = gsub('-','.',clin$PATIENT_ID)
phe=clin[match(colnames(expr),clin$PATIENT_ID),]

group_list=phe$CLAUDIN_SUBTYPE
table(group_list)

dat=expr
dat[1:4,1:4]
if(T){
  ddata=t(dat)
  ddata[1:4,1:4]
  s=colnames(ddata);head(s)
  library(org.Hs.eg.db)
  s2g=toTable(org.Hs.egSYMBOL)
  g=s2g[match(s,s2g$symbol),1];head(g)
  #  probe Gene.symbol Gene.ID
  dannot=data.frame(probe=s,
                    "Gene.Symbol" =s, 
                    "EntrezGene.ID"=g)
  ddata=ddata[,!is.na(dannot$EntrezGene.ID)]
  dannot=dannot[!is.na(dannot$EntrezGene.ID),] 
  head(dannot)
  library(genefu)
  # c("scmgene", "scmod1", "scmod2","pam50", "ssp2006", "ssp2003", "intClust", "AIMS","claudinLow")
  
  s<-molecular.subtyping(sbt.model = "pam50",data=ddata,
                         annot=dannot,do.mapping=TRUE)
  table(s$subtype)
  tmp=as.data.frame(s$subtype)
  subtypes=as.character(s$subtype)
}

library(genefu)
pam50genes=pam50$centroids.map[c(1,3)]
pam50genes[pam50genes$probe=='CDCA1',1]='NUF2'
pam50genes[pam50genes$probe=='KNTC2',1]='NDC80'
pam50genes[pam50genes$probe=='ORC6L',1]='ORC6'
x=dat
x=x[pam50genes$probe[pam50genes$probe %in% rownames(x)] ,]
dim(x)
tmp=data.frame(group=group_list,subtypes=subtypes)
rownames(tmp)=colnames(x)
table(tmp)
library(pheatmap)


pheatmap(x,show_rownames = T,show_colnames = F,
         annotation_col = tmp, 
         filename = file.path(wkdir,'figures','ht_by_pam50_raw.png') ) 


x=t(scale(t(x)))
x[x>1.6]=1.6
x[x< -1.6]= -1.6

pheatmap(x,show_rownames = T,show_colnames = F,
         annotation_col = tmp,
         filename = file.path(wkdir,'figures','ht_by_pam50_scale.png') ) 









