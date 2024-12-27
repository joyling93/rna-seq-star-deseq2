from rnanorm import TPM
import pandas as pd

fp = str(snakemake.input["counts"])
print(fp)
exp = pd.read_csv(fp, sep='\t', encoding='utf-8',index_col='gene')
tpm = TPM(str(snakemake.input["gtf"])).set_output(transform="pandas")
df = tpm.fit_transform(exp.T)
df = df.T
df.index.name = 'gene'
df.to_csv(str(snakemake.output[0]), sep='\t', index=True, encoding='utf-8')