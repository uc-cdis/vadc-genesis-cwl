# vadc-genesis

Argo workflows for VADC GWAS with GENESIS for use within the VADC data commons.

## vadc-gwas-tools

:information_source: See also the [vadc-gwas-tools](https://github.com/uc-cdis/vadc-gwas-tools) repository
for the implementation of the various custom tools used in these GWAS workflows.

# Deploying changes

Using **QA server** as example:

1. change `metadata/name` value in the `argo/gwas-workflows/qa.template.yml`, and update the
`metadata/annotations/version` and `metadata/annotations/description`:

```yaml
metadata:
  name: <NEW_NAME_HERE>
  annotations:
    version: <NEW.VERSION.HERE>
    description: |
        * DESCRIBE THE NEW VERSION'S CHANGES HERE
```
2. login to QA Gen3 portal https://qa-mickey.planx-pla.net/
3. go to workflow templates page in argo: https://qa-mickey.planx-pla.net/argo/workflow-templates/argo
4. click "create new workflow template"
5. upload the updated `argo/gwas-workflows/qa.template.yml` file
6. update the workflow template name in gitops.json to the same value as `metadata/name` in step 1. Do this in https://github.com/uc-cdis/gitops-qa repo and make PR
7. once PR of step 6 is merged, run:
```
ssh to QA server...
git -C ~/cdis-manifest pull
gen3 kube-setup-secrets
gen3 kube-setup-portal
```
