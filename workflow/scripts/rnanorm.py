from rnanorm import TPM
import pandas as pd
exp = pd.read_csv(snakemake.input["counts"], sep='\t', encoding='utf-8')

tpm = TPM(snakemake.input["gtf"]).set_output(transform="pandas")
df = tpm.fit_transform(exp)
df.to_csv(snakemake.output[0], sep='\t', index=False, encoding='utf-8')