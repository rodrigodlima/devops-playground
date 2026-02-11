# The Differences Between Runtime and Build-Time Variables

Do you know the difference between runtime and build-time variables?

It's a very important topic. It's not a complex topic — it's actually simple — but many professionals don't know about it, and it's important. If you understand it, you will avoid many problems in your deployments or builds.

## Runtime

It's simpler. All variables in runtime mode can be changed, and you only need to restart your application.
Execution-time (or runtime) variables are values loaded when the application starts or while it is running. This approach offers much greater flexibility and is the standard for modern, dynamic applications.

## Build Time

Build-time variables are static values compiled directly into the application's binary or code. They cannot be changed without recompiling and redeploying the application.


### Code examples

#### NextJS

For NextJS framework, environment variables used on the client-side must be defined at build time (prefixed with NEXT_PUBLIC_), because the browser cannot access server environment variables. However, for server-side code (API routes, Server Components, getServerSideProps), runtime environment variables can be used normally via process.env.

See the run-time-vs-buildtime directory. I created an example of buildtime. For it, it's necessary to create a .env.local file with the variables. If you need to change these variables, it is necessary to rebuild the application.
