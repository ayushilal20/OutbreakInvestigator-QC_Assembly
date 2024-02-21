#create conda env 'qual_eval' with python=3.7.12
conda create -n qual_eval python=3.7.12 -y
	
# Activate the 'qual_eval' environment
conda activate qual_eval

# Install required packages
pip install quast matplotlib

# Set the output directory
output_dir="./quast_results"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# List of tools
tools=("velvet" "skesa" "abyss")

# Loop through each tool's assemblies and run Quast
for tool in "${tools[@]}"; do
    tool_output_dir="$output_dir/$tool"
    mkdir -p "$tool_output_dir"

    # Run Quast for each assembly in the tool's directory
    for assembly in "./assemblies/$tool"/*.fa; do
        assembly_name=$(basename -- "$assembly" .fa)
        quast.py -o "$tool_output_dir/$assembly_name" "$assembly"
    done
done

# Deactivate the 'qual_eval' environment
conda deactivate
