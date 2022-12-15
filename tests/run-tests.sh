# Cleanup first
helm delete test-simple-app || true
helm delete test-everything-app || true

# Install with almost no values and analyze
echo "\n\n\n\n----------------------------- DEPLOYING TESTS WITH NO CONFIGS -----------------------------------\n\n\n\n"
helm template test-simple-app ../charts/k8ez --set-string image.image=redis --set service.port=80 --set securityContext.runAsUser=999 --set securityContext.runAsGroup=999 -n default
helm upgrade  test-simple-app ../charts/k8ez --set-string image.image=redis --set service.port=80 --set securityContext.runAsUser=999 --set securityContext.runAsGroup=999 -n default --install --wait

# Install with a ton of features enabled
echo "\n\n\n\n----------------------------- DEPLOYING TESTS WITH MANY CONFIGS ---------------------------------\n\n\n\n"
helm template test-everything-app ../charts/k8ez --values everything.values.yaml -n default
helm upgrade  test-everything-app ../charts/k8ez --values everything.values.yaml -n default --install --wait