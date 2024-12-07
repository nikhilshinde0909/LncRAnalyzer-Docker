data <- read.table(file="Aquilegia_coerulea.feature.xls",sep="\t",header=T)
attach(data)
mylogit <- glm(Label ~ mRNA + ORF + Fickett + Hexamer, family=binomial(link="logit"), na.action=na.pass)
save.image("Aquilegia_coerulea.logit.RData")
