#!/bin/bash

# Define the URLs of the RPM packages
urls=(
    "https://cdn.amazonlinux.com/al2023/core/guids/9cf1057036ef7d615de550a658447fad88617805da0cfc9b854ba0fb8a668466/x86_64/../../../../blobstore/97cf17475d1d338e712f5ac3f0e24d8268baacf6927e5b64c6d927ee8d875ae2/generic-logos-httpd-18.0.0-12.amzn2023.0.3.noarch.rpm"
    "https://cdn.amazonlinux.com/al2023/core/guids/9cf1057036ef7d615de550a658447fad88617805da0cfc9b854ba0fb8a668466/x86_64/../../../../blobstore/70724c2e0fbc93a82bdc60754bc14e4d6c5dbf7bf0a1e2365447b8e9b13359ba/httpd-filesystem-2.4.56-1.amzn2023.noarch.rpm"
    "https://cdn.amazonlinux.com/al2023/core/guids/9cf1057036ef7d615de550a658447fad88617805da0cfc9b854ba0fb8a668466/x86_64/../../../../blobstore/bae928f8dfd3459bb019c9e23a65f5bd1744ee2353976350334c8681262f7c09/apr-util-openssl-1.6.3-1.amzn2023.0.1.x86_64.rpm"
    "https://cdn.amazonlinux.com/al2023/core/guids/9cf1057036ef7d615de550a658447fad88617805da0cfc9b854ba0fb8a668466/x86_64/../../../../blobstore/bd2e3785aad759ef45ad1cff36696057e1acc6346ce22505e766888bfb3736a9/apr-util-1.6.3-1.amzn2023.0.1.x86_64.rpm"
    "https://cdn.amazonlinux.com/al2023/core/guids/9cf1057036ef7d615de550a658447fad88617805da0cfc9b854ba0fb8a668466/x86_64/../../../../blobstore/4eb7d1614968cc1b9db303f0699d3c6942e361a7df28d50306667f01f239c276/httpd-2.4.56-1.amzn2023.x86_64.rpm"
    "https://cdn.amazonlinux.com/al2023/core/guids/9cf1057036ef7d615de550a658447fad88617805da0cfc9b854ba0fb8a668466/x86_64/../../../../blobstore/035c31ebd6c16fe09b570b163f01eb914738f452b3bcfe4046d357ed875e2ee1/httpd-tools-2.4.56-1.amzn2023.x86_64.rpm"
    "https://cdn.amazonlinux.com/al2023/core/guids/9cf1057036ef7d615de550a658447fad88617805da0cfc9b854ba0fb8a668466/x86_64/../../../../blobstore/78d60b9a1d22510f7c68ab78b6e457785cedc7f149ca03dac976919f2d8f4784/mod_http2-2.0.11-2.amzn2023.x86_64.rpm"
    "https://cdn.amazonlinux.com/al2023/core/guids/9cf1057036ef7d615de550a658447fad88617805da0cfc9b854ba0fb8a668466/x86_64/../../../../blobstore/f08e0b0469eb609d00bdbcf5124dac34e352c03cc08ae9f194ecfe457ecf3d86/libbrotli-1.0.9-4.amzn2023.0.2.x86_64.rpm"
    "https://cdn.amazonlinux.com/al2023/core/guids/9cf1057036ef7d615de550a658447fad88617805da0cfc9b854ba0fb8a668466/x86_64/../../../../blobstore/19aeab704514ae459ec73d1ecfc2bc4bd3606052709ba5ce447df6f8c50df76f/mailcap-2.1.49-3.amzn2023.0.3.noarch.rpm"
    "https://cdn.amazonlinux.com/al2023/core/guids/9cf1057036ef7d615de550a658447fad88617805da0cfc9b854ba0fb8a668466/x86_64/../../../../blobstore/4595c00b2ce30225f952e308a4d156d5e842669f96a93b815b84a1d797b5a450/httpd-core-2.4.56-1.amzn2023.x86_64.rpm"
    "https://cdn.amazonlinux.com/al2023/core/guids/9cf1057036ef7d615de550a658447fad88617805da0cfc9b854ba0fb8a668466/x86_64/../../../../blobstore/15ccb2673464a7b761b0f23b8ee7fd196d78cc650e96a09918cefea478f59d4b/mod_lua-2.4.56-1.amzn2023.x86_64.rpm"
    "https://cdn.amazonlinux.com/al2023/core/guids/9cf1057036ef7d615de550a658447fad88617805da0cfc9b854ba0fb8a668466/x86_64/../../../../blobstore/86c87241c33b847c4d856e19f61ea7a7b4b7471f6b74b60bef4f925bb1264802/apr-1.7.2-2.amzn2023.0.2.x86_64.rpm"
)

# Create a directory to store the downloaded packages
download_dir="rpm_packages"
mkdir -p "$download_dir"

# Change to the download directory
cd "$download_dir" || exit

# Download each package using curl
for url in "${urls[@]}"; do
    echo "Downloading: $url"
    curl -O "$url"
done

echo "All packages have been downloaded."
