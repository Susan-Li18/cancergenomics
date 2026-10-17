# get libraries
library(tidyverse);library(magrittr)
# VEP output in
vep_data <- read.table("/data/users/jli/cancergenomics/07_annotation/chr6ch17_mutect2_annotated_with_clinVar.txt", 
                       header=F, 
                       sep="\t", 
                       comment.char="#")
# The standard VEP column names are:
colNames <- c("#Uploaded_variation", "Location", "Allele", "Gene", "Feature", "Feature_type",
              "Consequence", "cDNA_position", "CDS_position", "Protein_position", "Amino_acids",
              "Codons", "Existing_variation", "Extra")
# Set column names
colnames(vep_data) <- colNames
# Split when it contains multiple values
consequences_df <- vep_data %>%
  separate_rows(Consequence, sep = ",") %>%
  select(Consequence)
# get chr
vep_data <- vep_data %>%
  separate(Location, into = c("chr", "position"), sep=":") %>% 
  mutate(chr = factor(chr, levels = c("chr6", "chr17")))
# Extract IMPACT from Extra column
vep_data$IMPACT <- gsub(".*IMPACT=([^;]+).*", "\\1", vep_data$Extra)
# get nice data out of the df
extract_field <- function(data, field) {
  stringr::str_match(
    data$Extra,
    paste0("(?:^|;)", field, "=([^;]*)")
  )[, 2]
}
# combine multiple fields
vep_data <- vep_data %>%
  mutate(
    IMPACT = extract_field(., "IMPACT"),
    SYMBOL = extract_field(., "SYMBOL"),
    VARIANT_CLASS = extract_field(., "VARIANT_CLASS"),
    BIOTYPE = extract_field(., "BIOTYPE")
  )


# 1. Consequence plot, to visualize the distribution of consequences

# consequence plot
p1 <- ggplot(vep_data, aes(x=reorder(Consequence, table(Consequence)[Consequence]))) +
  geom_bar() +
  coord_flip() +
  theme_minimal() +
  labs(title="Distribution of \n Variant Consequences",
       x="Consequence Type",
       y="Count")
#2. Consequence plot, by chromosome

# consequence plot 
p2 <- ggplot(vep_data, aes(x=reorder(Consequence, table(Consequence)[Consequence]))) +
  geom_bar() +
  coord_flip() +
  theme_minimal() +
  labs(title="Distribution of \n Variant Consequences",
       x="Consequence Type",
       y="Count") +
  facet_grid(~chr) +
  theme(
    legend.position = "bottom"
  )

# Impact + Consequence plot
p3 <- ggplot(vep_data, aes(x=reorder(Consequence, table(Consequence)[Consequence]), fill=IMPACT)) +
  geom_bar() +
  coord_flip() +
  theme_minimal() +
  scale_fill_brewer(palette="Set1") +
  labs(title="Variant Consequences \n by Impact",
       x="Consequence Type",
       y="Count") +
  theme(
    legend.position = "bottom"
  )

# Impact + consequence plot x chr
p4 <- ggplot(vep_data, aes(x=reorder(Consequence, table(Consequence)[Consequence]), fill=IMPACT)) +
  geom_bar() +
  coord_flip() +
  theme_minimal() +
  scale_fill_brewer(palette="Set1") +
  labs(title="Variant Consequences \n by Impact",
       x="Consequence Type",
       y="Count") +
  facet_grid(~chr) +
  theme(
    legend.position = "bottom"
  )

# variant class plot
p5 <- vep_data %>%
  count(VARIANT_CLASS) %>%  # Count the classees
  arrange(desc(n)) %>%  # Sort in descending ord
  ggplot(aes(x = reorder(VARIANT_CLASS, n), y = n)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Distribution of \n Variant Classes",
       x = "Variant Class",
       y = "Count")

# biotype distribution
p6 <- ggplot(vep_data, aes(x=reorder(BIOTYPE, table(BIOTYPE)[BIOTYPE]))) +
  geom_bar(fill="steelblue") +
  coord_flip() +
  theme_minimal() +
  labs(title="Distribution of \n Biotypes",
       x="Biotype",
       y="Count")

# save plot
plots <- list(
  "01_consequence" = p1,
  "02_consequence_by_chr" = p2,
  "03_consequence_by_impact" = p3,
  "04_consequence_by_impact_chr" = p4,
  "05_variant_class" = p5,
  "06_biotype" = p6
)

output_dir <- "/data/users/jli/cancergenomics/plots"
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)
for (name in names(plots)) {
  ggsave(
    filename = file.path(output_dir, paste0(name, ".png")),
    plot = plots[[name]],
    width = 12,
    height = 8,
    dpi = 300
  )
}