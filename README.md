
[![Build Status](https://semaphoreci.com/api/v1/projects/595207c7-bd7a-4f61-b652-6edd94336e15/455117/badge.svg)](https://semaphoreci.com/zabirauf/ex_merkle_dag--2)

#MerkleDAG (In Development)

![Merkle Dag](https://cloud.githubusercontent.com/assets/1104560/8148112/f88a3a68-1240-11e5-9216-63449f98677d.png)

[Merkle DAG](https://github.com/jbenet/random-ideas/issues/20) is the data structure powering the Git and [IPFS](http://ipfs.io).
It has the benefits of
* Integrity check
* Deduplication
* Content Addressing

It can be used to build various awesome things and IPFS is a great example of it. This is an attempt to implement MerkleDAG in Elixir so that in the future other things can be built on top of it. It is using [Go-IPFS](https://github.com/ipfs/go-ipfs) implementation as reference.

It is still in **heavy development** and in no way functional yet.

#Resources
* [Merkle DAG](https://github.com/jbenet/random-ideas/issues/20)
* [Mathias Buus Slide for DTN 2015](http://mafintosh.github.io/slides/dtn-2015/)

#License

MIT

 
