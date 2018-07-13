## file node define
	file node,应该定义文件数据相关以及文件元数据相关的结构体


## treeNode define
	文件、文件夹组织方式为：树形结构。因此，应该采用treeNode方式，来构造文件-文件夹组织方式。

typedef struct TreeNode *PtrToNode;

typedef PtrToNode Tree;

struct TreeNode{
	
	int nodeType,//file,directory
	
	string fileName,
	int fileType,//video,normal,word...
	string filePath,
	
	array supportOperations,//support operations.maybe using enum which it's elments supportting logic bit operation is more good.
	
	bool hasFetchedSubTrees,//whether the treenode has successful fetched subtrees.
	
	Tree parent,//the TreeNode's parent node.if it is root,the parent is null.
	
	array subTrees,//the TreeNode's sub nodes if it is directory.otherwise the array is null. 
}
