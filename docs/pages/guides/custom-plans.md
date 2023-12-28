<extends template="layouts/index.html"></extends>

# Custom Plans

Packsnap allows you to build any type of project by passing your own derivations and configuration to `buildCustomPlan`.

```nix
buildCustomPlan : {
    name: ?string,
    tag: ?string,
    variables: ?[string],
    contents: [derivation],
    libraries: ?[string],
    start: string
} -> ?
```

See an example [here](https://github.com/aleksrutins/packsnap/tree/master/examples/custom-plan).