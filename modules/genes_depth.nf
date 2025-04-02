process calculateGenesDepth {
    tag "Extracting genes depth statistics from bam files"
    cpus 1
    memory '4GB'
    time '12h'

    input:
    path depth_file
    file "genome.bed"
    file "windows.bed"
    file "windows.list"
    file "genes.bed"
    file "genes.list"

    output:
    path "${depth_file[0].baseName}-genes.sorted.tsv"
    
    script:
    """
    awk '{print \$1"\\t"\$2"\\t"\$2"\\t"\$3}' $depth_file | bedtools map -a genes.bed -b stdin -c 4 -o mean -null 0 -g genome.bed | awk -F "\\t" '{print \$1":"\$2"-"\$3"\\t"\$4}' | sort -k1,1 > ${depth_file[0].baseName}-genes.tsv
    awk 'NR==FNR{a[\$1]=\$0; next} \$1 in a{print a[\$1]"\\t"\$2}' genes.list ${depth_file[0].baseName}-genes.tsv > ${depth_file[0].baseName}-genes.sorted.tsv
    """
}
