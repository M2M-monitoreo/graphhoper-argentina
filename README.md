./build.sh
mkdir -p data
run -p 8989:8989 -v $(pwd)/data:/data tu-usuario/graphhopper-argentina:latest
