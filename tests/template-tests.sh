# Template with almost no values and analyze
echo "\n\n\n\n----------------------------- RUNNING TESTS WITH NO CONFIGS -----------------------------------\n\n\n\n"
helm template test-simple-app ../charts/k8ez --set-string image.image=redis --set service.port=80 -n default > simple-app-test.yaml

# Template with a ton of features enabled
echo "\n\n\n\n----------------------------- RUNNING TESTS WITH MANY CONFIGS ---------------------------------\n\n\n\n"
helm template test-everything-app ../charts/k8ez --values everything.values.yaml -n default --set-string nameOverride=k8ez --set-string fullnameOverride=test-everything-app > full-features-test.yaml

echo "\n\n\n\n----------------------------- RUNNING TESTS WITH MANY CONFIGS AND ISTIO ---------------------------------\n\n\n\n"
helm template test-everything-app ../charts/k8ez --values everything.values.yaml --set-string nameOverride=ingress-nameOverride --set-string fullnameOverride=test-everything-app-ingress --set-string ingress.k8sIngress.enabled=false --set-string ingress.istio.enabled=true --set-string ingress.istio.forceHttpRedirect=true -n default > full-features-istio-test.yaml
