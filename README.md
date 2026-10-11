## Datasets

The analysis includes two types of datasets: tumor scRNA-seq datasets used to identify malignant cell states, and embryoid body scRNA-seq datasets used as references for early developmental programs.

We use publicly available single-cell RNA-seq datasets from several cancer types.
For datasets containing both malignant and non-malignant cells, only the malignant population was retained according to the annotations provided with each dataset.

| Dataset | Local data | Filtering / preparation | Cells retained | Source |
|---|---|---|---:|---|
| Breast cancer | `breast_cancer.rds` | `Cell_Type_Annotation == "Cancer Epithelial Cells"` | 75,883 | https://zenodo.org/records/10672250 |
| Breast epithelial | `breast_cancer_epithelial.rds` | Provided ready for analysis | — | https://cellxgene.cziscience.com/collections/dea97145-f712-431c-a223-6b5f565f362a |
| AML — Abbas 2021 | `scAML_Abbas_2021_projected_cleaned.rds` | `NormalvsMalignant == "AML"` | 60,665 | https://zenodo.org/records/18528442 |
| AML — Lasry 2022 | `scAML_Lasry_2022_projected_cleaned.rds` | `NormalvsMalignant == "malignant"` | 123,147 | https://zenodo.org/records/18528442 |
| AML — van Galen 2019 | `scAML_vanGalen_2019_projected_cleaned.rds` | `NormalvsMalignant == "malignant"` | 11,641 | https://zenodo.org/records/18528442 |
| B-ALL | `0607fd1a-a1b1-44e4-82f5-9c6d9f8e68b5.h5ad` | `Ctype == "Blasts"` | 88,228 | https://cellxgene.cziscience.com/collections/10ec9198-584e-4a7e-8a24-4a332915a4ef |
| Colon adenocarcinoma | `colon_cancer.rds` | Epithelial dataset; retained cells with `disease == "colon adenocarcinoma"` | 113,216 | https://cellxgene.cziscience.com/collections/4d82bd8e-8827-410b-8fc7-685b7dd92585 |
| Melanoma | `All_Celltypes_seurat_melanoma_joanna_revised.RDS` | Provided ready for analysis | — | https://zenodo.org/records/14511579 |

### Embryoid body reference datasets

Embryoid body (EB) scRNA-seq datasets were used as references for developmental
and differentiation-associated transcriptional programs.

| Dataset | Local data | Developmental context | GEO |
|---|---|---|---|
| Rhodes — GSE178274 | `GSE178274_EB_Rhodes.rds` | Broad human embryoid-body differentiation; used as a general early-development reference | [GSE178274](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE178274) |
| Doulatov — GSE274084 | `GSE274084_EB_Doulatov.rds` | iPSC embryoid-body differentiation focused on endothelial-to-hematopoietic transition | [GSE274084](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE274084) |
# План анализа

## Шаг 0. Отбор эталонных плюрипотентных клеток

Сначала по литературе собираем маркеры стволовой пластичности (плюрипотентности). По этим маркерам отбираем из эмбриоидных телец (EB) клетки, которые с достаточной уверенностью находятся в плюрипотентном состоянии. Дифференцированные клетки EB исключаем. Результат визуализируем.

## Шаг 1. Кластеризация

Кластеризуем клетки EB и опухолевых образцов t1, t2, t3 и так далее.

## Шаг 2. Поиск опухолевых подкластеров, похожих на EB

В каждом опухолевом образце ищем подкластеры, наиболее похожие на отобранные плюрипотентные клетки EB. Способ оценки сходства пока не выбран. Варианты: MANOVA, PERMANOVA или другие подходы.

## Шаг 3. Дифференциальная экспрессия

Строим псевдобалк и сравниваем две группы опухолевых кластеров:

- похожие на EB (`sim_clust_tumor`);
- непохожие на EB (`notsim_clust_tumor`).

Цель: найти дифференциально экспрессируемые гены (ДЭГ), которые определяют плюрипотентное состояние среди опухолевых клеток.

## Шаг 4. Сборка размеченного датасета

Объединяем клетки EB и опухоли в один датасет. Каждой клетке присваиваем метку состояния: PSK (плюрипотентная стволовая клетка) или not PSK.

## Шаг 5. Обучение модели

Обучаем классификатор на этом датасете. Строки соответствуют клеткам, столбцы содержат экспрессию генов g1…gN, а целевая переменная называется `cell_state`.

| Клетка | g1 | g2 | g3 | … | gN | cell_state |
|---|---|---|---|---|---|---|
| EB1 | | | | | | PSK |
| EB2 | | | | | | PSK |
| EB3 | | | | | | not PSK |
| … | | | | | | … |
| t1_1 | | | | | | not PSK |
| t1_2 | | | | | | not PSK |
| … | | | | | | PSK |
| t2_1 | | | | | | not PSK |
| t2_2 | | | | | | … |

## Обозначения

- **EB**: эмбриоидные тельца.
- **t1, t2, t3**: опухолевые образцы.
- **t1_1, t1_2**: клетки образца t1.
- **PSK**: плюрипотентная стволовая клетка.
