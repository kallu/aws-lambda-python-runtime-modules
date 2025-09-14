# aws-lambda-python-runtime-modules

Extract Python modules and versions included in different versions of AWS Lambda Python runtimes. There is ```pythonX.Y-requirements.txt``` -file containing available modules and versions for each available runtime. At the moment it doesn't seem to be possible to get a list of available runtimes programmatically so I'm using the list in ```runtimes``` that is updated from https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html

Requirements files are updated every Sunday at noon UTC.   
