CHECK_PROGRAMS=(docker docker-compose)
SHOULD_CONTINUE="true"

# Check if programs are installed
for i in "${CHECK_PROGRAMS[@]}"
do
    if ! command -v $i &> /dev/null
    then
        >&2 echo "$i could not be found, please install it"
        SHOULD_CONTINUE="false"
    fi
done


# Check if .env file exists
if [ ! -f .env ]; then
    read -rep "LetsEncrypt default email address: " -i "" answer
    echo "DEFAULT_EMAIL=${answer}" > .env
fi

# Check if .env file is empty
if [ ! -s .env ]; then
    >&2 echo ".env configuration is empty"
    read -rep "LetsEncrypt default email address: " -i "" answer
    echo "DEFAULT_EMAIL=${answer}" > .env
fi

# Check if .env file has DEFAULT_EMAIL
if ! grep -q "DEFAULT_EMAIL" .env; then
    >&2 echo ".env configuration is missing DEFAULT_EMAIL"
    read -rep "LetsEncrypt default email address: " -i "" answer
    echo "DEFAULT_EMAIL=${answer}" >> .env
fi


if [[ "${SHOULD_CONTINUE}" == "false" ]]; then
    >&2 echo "Please fix the issues listed above"
    exit 1
fi
  
# start docker compose
echo "Starting docker compose..."
docker-compose up --build -d

# show logs
echo "Showing logs..."
docker-compose logs -f