# Cancer Cell Plasticity: Exploring Embryonic Developmental Programs

## Project Purpose

This project investigates whether cancer cells reactivate gene-expression programs associated with early embryonic development. Using single-cell RNA sequencing (scRNA-seq), we aim to identify progenitor-like tumor cell states, compare their transcriptional profiles with embryoid-body cells, and explore how developmental programs may contribute to cancer cell plasticity, altered differentiation, and therapy resistance.

### Datasets

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



## Computational Pipeline

Our computational workflow combines single-cell RNA sequencing,
deep learning, unsupervised learning, and gene-signature analysis
to identify developmental-like transcriptional programs in cancer.

The analysis includes two complementary approaches:

1. Developmental reference modeling and cancer-cell mapping.
2. Exploratory cross-cancer feature preparation for supervised ML.

### 1. Data Preprocessing

**Tools:** Scanpy, Seurat, Python, R

- Load embryoid-body (EB) and cancer scRNA-seq datasets.
- Calculate quality-control metrics, including RNA counts,
  detected genes, and mitochondrial gene percentage.
- Remove low-quality cells and lowly expressed genes.
- Harmonize gene identifiers across datasets.
- Retain malignant cells where appropriate annotations exist.

**EB reference after QC:** 40,370 cells × 17,608 genes.

### 2. Developmental Reference Modeling

**Method:** scVI (Single-cell Variational Inference)

- Train a deep-learning model using the Rhodes EB dataset.
- Account for technical batch effects.
- Learn a 30-dimensional latent representation of EB cells.
- Generate UMAP visualizations and Leiden clusters.

**Output:** `models/eb_scvi_reference_filtered/`

### 3. Developmental Trajectory Inference

**Methods:** DPT and PAGA

- Identify an early developmental reference population
  using POU5F1, MYC, and NANOG.
- Calculate diffusion pseudotime (DPT).
- Use PAGA to examine relationships between EB cell populations.
- Characterize early, intermediate, and differentiated states.

**Output:** `eb_trajectories.h5ad`

### 4. Developmental Topic Discovery

**Method:** Non-negative Matrix Factorization (NMF)

- Obtain denoised gene-expression estimates from scVI.
- Apply NMF to identify 30 transcriptional topics.
- Extract genes contributing to each topic.
- Examine topic activity across EB clusters and pseudotime.
- Identify early, transient, and terminal developmental programs.
- Characterize dynamic gene modules along pseudotime.

**Outputs:**
- `gene_topic_weights.csv`
- `gene_modules_python.csv`
- `topic_scores_pseudobulk.csv`

### 5. Cancer-to-Embryoid Reference Mapping

**Method:** scArches

- Prepare 88,228 B-ALL blasts for analysis.
- Apply additional quality filtering.
- Match cancer gene identifiers to the EB reference.
- Map malignant cells into the trained scVI latent space.
- Examine similarities between cancer and developmental states.

**Output:** Cancer cells mapped to the EB reference.

### 6. Developmental Gene-Signature Scoring

**Method:** UCell

- Select the top 100 genes from each NMF topic.
- Construct EB-derived developmental gene signatures.
- Calculate signature scores for individual cancer cells.
- Identify cancer populations enriched for developmental programs.

**Output:** `bdata_projected.h5ad`

### 7. Plasticity-Associated Arrest Score

A custom score was developed to characterize candidate
abnormal developmental-like cancer states.

**Embryonicness:** Combines early, transient, and terminal
developmental-program activity.

**Aberrancy:** Combines reference distance, reconstruction
error, and topic entropy.

**Formula:**

    Embryonicness = clip(Early + Transient - Terminal, 0, 1)

    Aberrancy = 0.5 × Distance
              + 0.3 × Reconstruction Error
              + 0.2 × Topic Entropy

    Arrest Score = Embryonicness × Aberrancy

Individual components are normalized before combination.

Cells in the highest 25% of Arrest Scores are classified
as high-arrest candidates for exploratory analysis.

EB-reference pseudotime is also transferred to cancer cells
using weighted nearest-neighbor mapping.

**Output:** `arrest_scores.csv`

### 8. Biological Interpretation

**Methods:** GO, KEGG, ORA, GSEA

- Perform functional enrichment for the 30 NMF topics.
- Identify biological processes and molecular pathways
  associated with developmental gene programs.
- Explore transcription-factor-associated gene sets.
- Visualize topic activity, Arrest Scores, and pseudotime.
- Compare high- and low-Arrest-Score cell populations.
- Assess sensitivity to score formulas, weights, and thresholds.

**Outputs:** `results/topic_enrichment/`

### 9. Cross-Cancer Gene-Signature Analysis

**Tools:** R, Seurat, AddModuleScore

A complementary analysis examines five datasets:

- Embryoid bodies
- Acute myeloid leukemia (AML)
- Colon adenocarcinoma
- Breast cancer
- Melanoma

The workflow:

1. Harmonizes gene identifiers using HGNC mappings.
2. Normalizes expression using Seurat.
3. Calculates pluripotency-associated signature scores.
4. Visualizes expression patterns using UMAP and t-SNE.
5. Identifies highly variable genes in each dataset.
6. Finds highly variable genes shared across the datasets.
7. Exports aligned expression matrices and metadata.

**Result:** 329 shared highly variable genes.

**Output:** `export_hvg/`

### 10. Machine-Learning Data Preparation

**Tools:** Python, Pandas, NumPy, SciPy, scikit-learn

The notebook `prepared_for_ML.ipynb`:

- Loads the five exported expression matrices.
- Aligns all datasets to the same 329 gene features.
- Applies library-size normalization and log transformation.
- Standardizes gene expression within each dataset.
- Creates preliminary candidate stem-like labels using
  EB cluster assignments and colon cell annotations.
- Combines EB and colon datasets into a training table.
- Retains dataset and patient identifiers.
- Performs preliminary evaluation of the PluriScore21
  signature against colon stem-cell annotations.

**Training table:**
- 155,704 cells
- 329 gene-expression features
- Preliminary binary cell-state labels

**Output:** `train_eb_colon.csv.gz`

**Preliminary result:** PluriScore21 ROC-AUC = 0.402
against colon stem-cell annotations.

These labels are exploratory proxies and do not
establish experimentally confirmed pluripotency.

### 11. Supervised Machine Learning — HGBoost

**Model:** HGBoost

HGBoost has been selected for the supervised-learning
branch to investigate classification of candidate
stem-like or developmental-like cancer cells.

**Current documentation status:** Training code,
saved model, and independent evaluation results
have not yet been included in the documented files.

The intended inputs include:
- Harmonized gene-expression features
- Preliminary cell-state labels
- Dataset and patient identifiers

### 12. External Validation — Planned

The next stage will evaluate the framework on
independent cancer datasets.

Planned analyses include:

- Application to additional malignancies.
- Comparison of developmental programs across cancers.
- Analysis of diagnosis-versus-relapse samples.
- Investigation of premalignant and malignant states.
- Patient-level comparison of high- and low-scoring groups.
- Evaluation of associations with clinical outcomes.
