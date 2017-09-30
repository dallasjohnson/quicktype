#!/bin/sh

OUTDIR=dist

npm install --ignore-scripts
bower install --allow-root
pulp build --build-path $OUTDIR -- --source-maps --stash --censor-warnings

# Move TypeScript typings next to PureScript JavaScript modules
for typeFile in @types/*.d.ts; do
    filename=$(basename $typeFile)
    module="${filename%%.d.ts}"
    ln -f $typeFile $OUTDIR/$module/
done

tsc --project cli/tsconfig.json

# Rewrite `require("Module")` as `require("./Module")` for PureScript modules
#
# TODO I hate this, but after two weeks trying to make TypeScript, PureScript,
# and JavaScript play nicely together, I'm saying "fuck it".
#
# Imports have to be absolute to compile, but relative to run. Seriously, fuck it.
for typeFile in @types/*.d.ts; do
    filename=$(basename $typeFile)
    module="${filename%%.d.ts}"
    # TODO this currently only works for top-level
    for script in cli/*.js; do
        sed -i -e "s/require(\"$module\")/require(\"\.\/$module\")/g" $script
    done
done

# Distribute README, TypeScript, etc.
rm -f cli/*-e # remove artifacts from sed(?)
cp cli/* $OUTDIR/

(echo "#!/usr/bin/env node"; cat cli/quicktype.js) > $OUTDIR/quicktype.js
chmod +x $OUTDIR/quicktype.js

rm -f cli/*.js