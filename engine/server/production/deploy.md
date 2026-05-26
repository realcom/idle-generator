## S3 deployment

### via GitHub Actions

* Put build artifacts in the `Build` directory.
* Push to the `production-build` branch to deploy the client to S3.





### DEPRECATED

- **DEPRECATED**: This deployment will done automatically by the GitHub Actions workflow.

- Configure AWS
  * Use authorized AWS Access Key ID
  * Use authorized AWS Secret Access Key
```sh
aws configure
```
```yaml
AWS Access Key ID: (AWS Access Key ID)
AWS Secret Access Key: 
Default region name: ap-southeast-1
```

- Clone the server repo
```sh
cd /home/ubuntu
git clone --depth 1 --no-checkout https://github.com/puzzlemonsters/idlez-server -b production
cd idlez-server
git config core.sparseCheckout true
echo "production/s3.py" >> .git/info/sparse-checkout
git checkout HEAD
chmod +x production/s3.py
```

- Use s3.py to deploy the client
```sh
cd production
python3 s3.py
```


* AWS S3 and AWS Cloudfront

### Note

* Brotli compression is only supported for HTTPS connections.
