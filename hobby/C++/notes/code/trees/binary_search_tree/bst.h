#ifndef BINARYSEARCHTREE_H
#define BINARYSEARCHTREE_H

#include <iostream>
#include <utility>

template<typename T>
class BinarySearchTree
{
    public:
        BinarySearchTree();
        BinarySearchTree(const BinarySearchTree & rhs);
        BinarySearchTree(BinarySearchTree && rhs);
        ~BinarySearchTree();

        const T & findMin() const;
        const T & findMax() const;
        bool contains (const T & x) const;
        bool isEmpty() const;
        void printTree(std::ostream & out = std::cout) const;

        void makeEmpty();
        void insert(const T & x);
        void insert(T && x);
        void remove(const T & x);

        BinarySearchTree & operator=(const BinarySearchTree & rhs);
        BinarySearchTree & operator=(BinarySearchTree && rhs);

    private:
        struct BinaryNode
        {
            T element;
            BinaryNode *left;
            BinaryNode *right;

            BinaryNode(const T & theElement, BinaryNode *lt, BinaryNode *rt)
                : element{ theElement }, left{ lt }, right{ rt } {}

            BinaryNode(T && theElement, BinaryNode *lt, BinaryNode *rt)
                : element{ std::move( theElement ) }, left{ lt }, right{ rt } {}
        };

        BinaryNode *root;

        void insert(const T & x, BinaryNode *& t);
        void insert(T && x, BinaryNode *& t);
        void remove(const T & x, BinaryNode *& t);
        BinaryNode * findMin(BinaryNode *t) const;
        BinaryNode * findMax(BinaryNode *t) const;
        bool contains(const T & x, BinaryNode *t) const;
        void makeEmpty(BinaryNode *& t);
        void printTree(BinaryNode *t, std::ostream & out) const;
        BinaryNode * clone(BinaryNode *t) const;
};

#endif
