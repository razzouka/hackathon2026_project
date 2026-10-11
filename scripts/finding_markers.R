library(Seurat)
melanoma <- readRDS('nas/data/melanoma/All_Celltypes_seurat_melanoma_joanna_revised.RDS')

eb <- readRDS('nas/data/EB/GSE178274_EB_Rhodes/GSE178274_EB_Rhodes.rds')

pluri_genes <- list(c("POU5F1", "MYC", "NANOG"))

eb_pluropotency_mark <- AddModuleScore(
  object = eb,
  features = pluri_genes,
  name = "PluriScore",
  ctrl = 100 # Количество контрольных генов
)

# Визуализация на UMAP
FeaturePlot(
  eb_pluropotency_mark,
  features = "PluriScore1",
  cols = c("blue", "white", "red")
)

DimPlot(
  eb,
  reduction = "umap",
  group.by = "seurat_clusters",   # какая колонка метаданных задаёт цвет
  label = TRUE,                    # подписать кластеры цифрами
  label.size = 5,
  repel = TRUE,                    # растащить подписи, если налезают
  pt.size = 0.4,
  cols = NULL                      # своя палитра, если нужно
)

# raw count matrix
Matrix::writeMM(eb@assays$RNA$counts,"~/shared_group/EB/EB_Rhodes_counts.csv")
# metadata 
write.csv(eb@meta.data, "~/shared_group/EB/EB_Rhodes_metadata.csv")

melanoma_pluropotency_mark <- AddModuleScore(
  object = melanoma,
  features = pluri_genes,
  name = "PluriScore",
  ctrl = 100 # Количество контрольных генов
)

FeaturePlot(
  melanoma_pluropotency_mark,
  
  features = "PluriScore1",
  cols = c("blue", "white", "red")
)

DimPlot(
  melanoma,
  reduction = "umap",
  group.by = "seurat_clusters",   # какая колонка метаданных задаёт цвет
  label = TRUE,                    # подписать кластеры цифрами
  label.size = 2,
  repel = TRUE,                    # растащить подписи, если налезают
  pt.size = 0.4,
  cols = NULL                      # своя палитра, если нужно
)
