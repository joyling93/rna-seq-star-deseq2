import sys
import os
import re
# logging
sys.stderr = open(snakemake.log[0], "w")

import pandas as pd
df = pd.read_csv(snakemake.config["samples"], sep='\t', header=0)
outdir = snakemake.output[0]
b2_level = snakemake.config["diffexp"]["variables_of_interest"]["condition"]["base_level"]
b1_level = snakemake.params["contrast"]["level_of_interest"]
b2_sample = '|'.join(df["sample_name"][df["condition"].isin([b2_level])].tolist())
b1_sample = '|'.join(df["sample_name"][df["condition"].isin([b1_level])].tolist())
# for s in snakemake.input.aln:
#     if s in b2_sample:
#         with open(snakemake.output[0], "w") as f:
b1 = ','.join([s for s in snakemake.input["aln"] if re.search(b1_sample,s)])
b1_f = os.path.join("results/rmats/",f"{b1_level}.txt")
if not os.path.exists(b1_f):
    with open(b1_f, "w", encoding="utf-8") as file:
        file.write(b1)

b2 = ','.join([s for s in snakemake.input["aln"] if b2_sample in s])
b2_f = os.path.join("results/rmats/",f"{b2_level}.txt")
if not os.path.exists(b2_f):
    with open(b2_f, "w", encoding="utf-8") as file:
        file.write(b2)

cmd = f"python /public/home/weiyifan/miniforge3/envs/rmats/bin/rmats.py --b1 {b1_f} --b2 {b2_f} --gtf resources/genome.gtf -t paired --readLength 50 --nthread {snakemake.threads[0]} --od {outdir} --tmp {outdir}_tmp"
print(cmd)
import subprocess

# 运行shell命令
result = subprocess.run(cmd, capture_output=True, text=True)

# 打印命令输出
print(result.stdout)