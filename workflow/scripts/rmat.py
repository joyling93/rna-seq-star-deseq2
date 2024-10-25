import pandas as pd
df = pd.read_csv(snakemake.config["samples"], sep='\t', header=0)
outdir = snakemake@output[0]
b2_level = snakemake@config[["diffexp"]][["variables_of_interest"]][["base_level"]]
b1_level = snakemake@params[["level_of_interest"]]
b2_sample = df["sample_name"][df["condition"].isin([b2_level])].tolist()
b1_sample = df["sample_name"][df["condition"].isin([b1_level])].tolist()
# for s in snakemake@input.aln:
#     if s in b2_sample:
#         with open(snakemake.output[0], "w") as f:
b1 = ','.join([s for s in snakemake@input["aln"] if b1_sample in s])
b2 = ','.join([s for s in snakemake@input["aln"] if b2_sample in s])
cmd = f"python /public/home/weiyifan/miniforge3/envs/rmats/bin/rmats.py --b1 {b1} --b2 {b2} --gtf resources/genome.gtf -t paired --readLength 50 --nthread 4 --od {outdir} --tmp rmat_tmp"
print(cmd)
import subprocess

# 运行shell命令
result = subprocess.run(cmd, capture_output=True, text=True)

# 打印命令输出
print(result.stdout)