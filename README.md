Kidroid - poor man's KiCad automation
=====================================


Introduction
------------

Kidroid is a simple script used to automate production of some artefacts for your KiCad board. More specifically, it
can be used to generate the following:
- fabrication bundle, containing gerber and drill files;
- documentation bundle, contianing schematics, layer drawings and interactive BOM.

Currently, only MacOS is supported, although it should be easy to port it to other *nix platforms.

Kidroid is purposely simple with a very restricted feature set. If it does not suit your needs, I would recommend
looking at far better solutions, such as [Kibot|https://github.com/INTI-CMNB/KiBot].



Rationale
---------

Kidroid was developed as an alternative to Kibot, specifically for my use case. More specifically, I had been 
successfully using Kibot for many months, but when I upgraded KiCad to version 7, Kibot did not work anymore
in my setup. I can only guess some time was to be required for Kibot to properly support KiCad 7. Anyway, since I
needed to produce some artefacts, I decided to script the production of those, using the new KiCad 7 CLI.

As a benefit, since the solution is quite simple, it has the following benefits:
- the integration with KiCad is very loose (I believe), so that it should be more resilient to future changes in
  KiCad
- it has very little dependencies to external tools and libraries, and in particular, does not rely on deploying
  python dependencies inside the KiCad python environment.
  

Usage
-----

Currently, no command-line options are provided, although it might change in the near future. Hence:
1. CD into the directory containing your kicad project (.kicad_pro file)
2. Invoke kidroid, it will generate the bundles

Note: in your Kicad project, you need to define a text variable named "revision", which will be used to generate
the file names.


Deployment
----------

Just put the script directory somewhere, including sub-folders. Be sure to checkout the git submodule for 
InteractiveHtmlBom.

Apart from the usual Posix commands, the script needs the following dependencies:
- jq
- zip
- kicad 7 or above (obviously)


FAQs
----

- Why didn't you simply update Kibot to be compatible with KiCad 7?
   - Because I needed to have a solution within 48h, but most probably I could never have been able to sort out Kibot
     in such a timeframe. I then decided it might be useful to package this "solution" neatly for others who might
     need it.
     
- Why didn't you implement it in Python?
   - Because, given the feature set I envisioned, it seemed to me that using shell scripts would be the best tool for
     the job. Additionally, using plain scripts means very few dependencies, and no need to deal with the Kicad's pip
     matter, which is not nicely solved on MacOs.
     
- Why didn't you implement it in Powershell?
   - Are you nuts? :-) Joke aside, PowerShell is not part of my set of hammers, and I needed to see this problem as a
     nail.
     


  