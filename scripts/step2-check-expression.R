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
# 把表达矩阵文本文件，读入到R语言
if(F){
  expr=read.table('~/Downloads/data_expression.txt',header = T,sep='\t')
  dim(expr)
  expr[1:4,1:4]
  length(unique(expr$Hugo_Symbol))
  gs=expr$Hugo_Symbol
  expr=expr[,-c(1,2)] 
  # 为了节省空间，我取小数点前两位
  expr <- apply(expr, 2, function(x){
    as.numeric(format(x,digits = 2))
  })
  rownames(expr)=gs
  expr=na.omit(expr)
  save(expr,file=file.path(wkdir,'data','metabric_expression.Rdata'))
}
load(file=file.path(wkdir,'data','metabric_expression.Rdata'))
dim(expr)
expr[1:4,1:4]
load(file=file.path(wkdir,'data','metabric_clinical.Rdata'))
dim(clin)
clin[1:4,1:4]
clin$PATIENT_ID = gsub('-','.',clin$PATIENT_ID)
phe=clin[match(colnames(expr),clin$PATIENT_ID),]

phe$gene=as.numeric(expr['BRCA1',])
colnames(phe)
table(phe$HER2_SNP6)
library(ggstatsplot)
library(ggplot2)
ggbetweenstats(data = phe, x = HER2_SNP6,  y = gene)
ggsave(file=file.path(wkdir,'figures','BRCA1_expression_by_HER2_SNP6_CNA.png'))

# 饼图
table(phe$CLAUDIN_SUBTYPE)
library(ggstatsplot)
# phe$subtype <- factor(phe$Recomputed_Subtype,levels = c("Normal","Her2","LumB","LumA","Basal"))
ggpiestats(data = phe,
           main = HER2_SNP6 ,                
           condition = CLAUDIN_SUBTYPE , 
           palette = "Set1" )
ggsave(file=file.path(wkdir,'figures','HER2_SNP6_CNA_by_subtype.png'))







