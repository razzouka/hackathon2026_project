## Datasets

The analysis includes two types of datasets: tumor scRNA-seq datasets used to identify malignant cell states, and embryoid body scRNA-seq datasets used as references for early developmental programs.

We use publicly available single-cell RNA-seq datasets from several cancer types.
For datasets containing both malignant and non-malignant cells, only the malignant population was retained according to the annotations provided with each dataset.

| Dataset | Local data | Filtering / preparation | Cells retained | Source |
|---|---|---|---:|---|
| Breast epithelial | `breast_cancer_epithelial.rds` | Provided ready for analysis | — | https://cellxgene.cziscience.com/collections/dea97145-f712-431c-a223-6b5f565f362a |
| AML — Abbas 2021 | `scAML_Abbas_2021_projected_cleaned.rds` | `NormalvsMalignant == "AML"` | 60,665 | https://zenodo.org/records/18528442 |
| Colon adenocarcinoma | `colon_cancer.rds` | Epithelial dataset; retained cells with `disease == "colon adenocarcinoma"` | 113,216 | https://cellxgene.cziscience.com/collections/4d82bd8e-8827-410b-8fc7-685b7dd92585 |
| Melanoma | `All_Celltypes_seurat_melanoma_joanna_revised.RDS` | Provided ready for analysis | — | https://zenodo.org/records/14511579 |

### Embryoid body reference datasets

Embryoid body (EB) scRNA-seq datasets were used as references for developmental
and differentiation-associated transcriptional programs.

| Dataset | Local data | Developmental context | GEO |
|---|---|---|---|
| Rhodes — GSE178274 | `GSE178274_EB_Rhodes.rds` | Broad human embryoid-body differentiation; used as a general early-development reference | [GSE178274](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE178274) |
