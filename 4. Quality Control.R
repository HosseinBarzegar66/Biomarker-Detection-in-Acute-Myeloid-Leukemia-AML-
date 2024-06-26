#### Quality Control ####

# transform raw counts into normalized values
vsd <- varianceStabilizingTransformation(dds, blind=T)

# Hierarchical Clustering

# Sample Distance Matrix
library("RColorBrewer")
library("gplots")

sampleDists <- dist(t(assay(vsd)))

sampleDistMatrix <- as.matrix(sampleDists)
rownames(sampleDistMatrix) <- paste(colnames(vsd), vsd$type, sep="")
colnames(sampleDistMatrix) <- paste(colnames(vsd), vsd$type, sep="")
colors <- colorRampPalette( rev(brewer.pal(8, "Blues")) )(255)
heatmap(sampleDistMatrix,col=colors,margin = c(8,8))
# samples vs samples



# Heatmap of the top 500 DEGs 
select <- order(rowMeans(counts(dds,normalized=T)),decreasing=T)[1:100]
my_palette <- colorRampPalette(c("blue",'white','red'))(n=100)
heatmap.2(assay(vsd)[select,], col=my_palette,
          scale="row", key=T, keysize=1, symkey=T,
          density.info="none", trace="none",
          cexCol=0.6, labRow=F,
          main="Heatmap of the top 500 DEGs in Cancer")
# samples vs genes



##########
# Principal Components Analysis
# Reduction of dimensionality to be able to retrieve 
# main differences / underlying variance between samples
# By default the functions use the top 500 most variable genes
# Plotting PCA1 using vsd method
dev.off()
plotPCA(vsd, intgroup="group")


##another PCA
library("genefilter")
library("ggplot2")
library("grDevices")
library("ggrepel")


pc <- prcomp(t(assay(vsd)[select,]))


# set condition
group <- ddsHTSeq$group

scores <- data.frame(pc$x, group)
scores$group=group
scores$rn <- rownames(scores)
(pcaplot <- ggplot(scores, aes(x = PC1, y = PC2, col = (factor(group))))
  + geom_point(size = 4)
  + ggtitle("Principal Components")
  + scale_colour_brewer(name = " ", palette = "Set1")
  #+ geom_text(label=scores$rn,size = 3)
  + geom_text_repel(label=scores$rn, size = 3)
  + theme(
    plot.title = element_text(face = 'bold'),
    legend.position = c(0.8,0.8),
    legend.key = element_rect(fill = 'NA'),
    legend.text = element_text(size = 10, face = "bold"),
    axis.text.y = element_text(colour = "Black"),
    axis.text.x = element_text(colour = "Black"),
    axis.title.x = element_text(face = "bold"),
    axis.title.y = element_text(face = 'bold'),
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank(),
    panel.background = element_rect(color = 'black',fill = NA)
  )) 

