# Template with almost no values and analyze
echo "\n\n\n\n----------------------------- RUNNING TESTS WITH NO CONFIGS -----------------------------------\n\n\n\n"
helm template test-simple-app ../charts/k8ez --set-string image.image=redis --set service.port=80 -n default > simple-app-test.yaml

# Template with a ton of features enabled
echo "\n\n\n\n----------------------------- RUNNING TESTS WITH MANY CONFIGS ---------------------------------\n\n\n\n"
helm template test-everything-app ../charts/k8ez --values everything.values.yaml -n default > full-features-test.yaml
