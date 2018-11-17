# w203_proj3
Project 3 for W203 Fall 2018


Contributors: Alex West, Jason Baker, John Boudreaux

## Git instructions

By now, we've all cloned the repository, so no need for us to talk about that.

Your typical workflow should be __pull -> work -> add -> commit -> push__ on your appropriate branch in order to avoid merge conflicts (if these come up, I'm happy to help).

### creating and navigating branches
When you first start up, navigate to your appropriate directory in git bash. Ensure you are on your correct branch by using
```
git status
```

If you need to change branches, use
```
git checkout existing_branch_name
```

If you're looking to create a new branch, keep in mind that it will do so from the existing state of the branch you are currently on. For example, if I am working in `john_feature` and I create a new branch, it will be based on the existing state of `john_feature` and not `master`. In some cases this may make sense, but I think for the most part it makes sense for us to create branches only off the master.

To navigate to master branch, simply check it out
```
git checkout master
```
To create a new branch from your current working branch
```
git branch new_branch_name
```
You can now checkout the new branch and work in it.
```
git checkout new_branch_name
```
### typical workflow
Once you're ready to work and have navigated to your branch, the first thing to do is to pull any changes that might have occured to the branch. Doing this first thing will help us avoid merge conflicts. Because we are working on separate branches, this should be clean.
```
git pull origin current_working_branch
```
Now your local PC has the same content as github for your branch. Start working and doing whatever you want.

When you have made changes that you would like to save as an update to push up for the rest of us to see on github, follow this procedure...

__1) check the changes you've made__
```
git status
```

This lists all the changes you've made. 

__2) add changes__

You need to tell git that you want to keep the changes in the new version. This can be done by manually adding each changed file, or by adding all at once.

To add a file individually, use
```
git add sample_file.txt
```
To add all changes, use
```
git add .
```

__3) commit changes__

Now that you've added your changes, they're ready to be saved as a distinct version, called a commit. To save these, use
```
git commit -m "message for what i did in this commit"
```
Now the files are saved locally to your PC as a distinct version with this commit.

__4) push changes to github__

The last thing is to push your new commit up to github so the rest of us can see it and have access. To do this, use
```
git push origin current_working_branch
```
You may need to provide your credentials for github. Once this goes through, your changes will be on github for everyone to utilize!

One last note: if you want, you can stack up multiple commits on your local PC and push them later. For example, I may work and make 5 commits because I think they are 5 good versions to capture. When I use my `git push` command afterwards, it will push all 5 commits at the same time and I will have access to all 5 in github.

Happy git-ing!
