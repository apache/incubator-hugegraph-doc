---
title: "Participate in Contributing"
linkTitle: "Participate in Contributing"
weight: 1
---

This guide documents the best way to make various types of contribution to Apache HugeGraph,
including what is required before submitting a code change.

Contributing to HugeGraph doesn't just mean writing code. Helping new users on the mailing list,
testing releases, and improving documentation are also welcome. In fact, proposing significant
code changes usually requires first gaining experience and credibility within the community by
helping in other ways. This is also a guide to becoming an effective contributor.

So, this guide organizes contributions in order that they should probably be considered by new
contributors who intend to get involved long-term. Build some track record of helping others,
rather than just open pull requests.

## Contributing by helping other users

A great way to contribute to HugeGraph is to help answer user questions on the `dev@hugegraph.org`
mailing list or on StackOverflow. There are always many new HugeGraph users; taking a few minutes to
help answer a question is a very valuable community service.

Contributors should subscribe to this list and follow it in order to keep up to date on what's
happening in HugeGraph. Answering questions is an excellent and visible way to help the community,
which also demonstrates your expertise.

See the [Mailing Lists guide](https://lists.apache.org/list.html?dev@hugegraph.org) for guidelines
about how to effectively participate in discussions on the mailing list, as well as forums
like ISSUE.

## Contributing by testing releases

HugeGraph's release process is community-oriented, and members of the community can vote on new
releases on the `dev@hugegraph.org` mailing list. HugeGraph users are invited to subscribe to
this list to receive announcements, and test their workloads on newer release and provide
feedback on any performance or correctness issues found in the newer release.

## Contributing by reviewing changes

Changes to HugeGraph source code are proposed, reviewed and committed via
[GitHub pull requests ](https://github.com/apache/incubator-hugegraph/pulls) (described later).
Anyone can view and comment on active changes here.
Reviewing others' changes is a good way to learn how the change process works and gain exposure
to activity in various parts of the code. You can help by reviewing the changes and asking
questions or pointing out issues -- as simple as typos or small issues of style.

## Contributing documentation changes

To propose a change to _release_ documentation (that is, docs that appear under
[docs](https://github.com/apache/incubator-hugegraph-doc/tree/master/content/en/docs)
edit the Markdown source files in HugeGraph's
[docs](https://github.com/apache/incubator-hugegraph-doc/tree/master/content/en/docs) directory,
whose `README` file shows how to build the documentation locally to test your changes.
The process to propose a doc change is otherwise the same as the process for proposing code
changes below.

To propose a change to the rest of the documentation (that is, docs that do _not_ appear under
[docs](https://github.com/apache/incubator-hugegraph-doc/tree/master/content/en/docs) , similarly, edit the Markdown in the
[website](https://github.com/apache/incubator-hugegraph-doc) and open a pull request.

## Contributing bug reports

Ideally, bug reports are accompanied by a proposed code change to fix the bug. This isn't
always possible, as those who discover a bug may not have the experience to fix it. A bug
may be reported by creating a ISSUE but without creating a pull request (see below).

Bug reports are only useful however if they include enough information to understand, isolate
and ideally reproduce the bug. Simply encountering an error does not mean a bug should be
reported; as below, search ISSUE and search and inquire on the HugeGraph user / dev mailing lists
first. Unreproducible bugs, or simple error reports, may be closed.

It's very helpful if the bug report has a description about how the bug was introduced, by
which commit, so that reviewers can easily understand the bug. It also helps committers to
decide how far the bug fix should be backported, when the pull request is merged. The pull
request to fix the bug should narrow down the problem to the root cause.

Performance regression is also one kind of bug. The pull request to fix a performance regression
must provide a benchmark to prove the problem is indeed fixed.

Note that, data correctness/data loss bugs are very serious. Make sure the corresponding bug
report ISSUE ticket is labeled as `correctness` or `data-loss`. If the bug report doesn't get
enough attention, please send an email to `dev@hugegraph.org`, to draw more attentions.

It is possible to propose new features as well. These are generally not helpful unless
accompanied by detail, such as a design document and/or code change. Large new contributions
should consider be discussed on the mailing list first.
Feature requests may be rejected, or closed after a long period of inactivity.

## Contributing to ISSUE maintenance

Given the sheer volume of issues raised in the Apache HugeGraph ISSUE, inevitably some issues are
duplicates, or become obsolete and eventually fixed otherwise, or can't be reproduced, or could
benefit from more detail, and so on. It's useful to help identify these issues and resolve them,
either by advancing the discussion or even resolving the ISSUE. Most contributors are able to
directly resolve ISSUEs. Use judgment in determining whether you are quite confident the issue
should be resolved, although changes can be easily undone. If in doubt, just leave a comment
on the ISSUE.

When resolving ISSUEs, observe a few useful conventions:

- Resolve as **Fixed** if there's a change you can point to that resolved the issue
    - Set Fix Version(s), if and only if the resolution is Fixed
    - Set Assignee to the person who most contributed to the resolution, which is usually the person
      who opened the PR that resolved the issue.
    - In case several people contributed, prefer to assign to the more 'junior', non-committer contributor
- For issues that can't be reproduced against master as reported, resolve as **Cannot Reproduce**
    - Fixed is reasonable too, if it's clear what other previous pull request resolved it. Link to it.
- If the issue is the same as or a subset of another issue, resolved as **Duplicate**
    - Make sure to link to the ISSUE it duplicates
    - Prefer to resolve the issue that has less activity or discussion as the duplicate
- If the issue seems clearly obsolete and applies to issues or components that have changed
  radically since it was opened, resolve as **Not a Problem**
- If the issue doesn't make sense – not actionable, for example, a non-HugeGraph issue, resolve
  as **Invalid**
- If it's a coherent issue, but there is a clear indication that there is not support or interest
  in acting on it, then resolve as **Won't Fix**
- Umbrellas are frequently marked **Done** if they are just container issues that don't correspond
  to an actionable change of their own

## Preparing to contribute code changes

### Choosing what to contribute

Review can take hours or days of committer time. Everyone benefits if contributors focus on
changes that are useful, clear, easy to evaluate, and already pass basic checks.

Sometimes, a contributor will already have a particular new change or bug in mind. If seeking
ideas, consult the list of starter tasks in ISSUE, or ask the `dev@hugegraph.org` mailing list.

Before proceeding, contributors should evaluate if the proposed change is likely to be relevant,
new and actionable:

- Is it clear that code must change? Proposing a ISSUE and pull request is appropriate only when a
  clear problem or change has been identified. If simply having trouble using HugeGraph, use the mailing
  lists first, rather than consider filing a ISSUE or proposing a change. When in doubt, email
  `dev@hugegraph.org` first about the possible change
- Search the `dev@hugegraph.org` mailing list for
  related discussions.
  Often, the problem has been discussed before, with a resolution that doesn't require a code
  change, or recording what kinds of changes will not be accepted as a resolution.
- Search ISSUE for existing issues:
  [ISSUES](https://github.com/apache/incubator-hugegraph/issues)
- Type `HugeGraph [search terms]` at the top right search box. If a logically similar issue already
  exists, then contribute to the discussion on the existing ISSUE and pull request first, instead of
  creating a new one.
- Is the scope of the change matched to the contributor's level of experience? Anyone is qualified
  to suggest a typo fix, but refactoring core scheduling logic requires much more understanding of
  HugeGraph. Some changes require building up experience first (see above).

It's worth reemphasizing that changes to the core of HugeGraph, or to highly complex and important modules are more difficult to make correctly. They will be subjected to more scrutiny
and held to a higher standard of review than changes to less critical code.

### Error message guidelines

Exceptions thrown in HugeGraph should be associated with standardized and actionable
error messages.

Error messages should answer the following questions:

- **What** was the problem?
- **Why** did the problem happen?
- **How** can the problem be solved?

When writing error messages, you should:

- Use active voice
- Avoid time-based statements, such as promises of future support
- Use the present tense to describe the error and provide suggestions
- Provide concrete examples if the resolution is unclear
- Avoid sounding accusatory, judgmental, or insulting
- Be direct
- Do not use programming jargon in user-facing errors

### Code review criteria

Before considering how to contribute code, it's useful to understand how code is reviewed,
and why changes may be rejected. See the
[detailed guide for code reviewers](https://google.github.io/eng-practices/review/)
from Google's Engineering Practices documentation.
Simply put, changes that have many or large
positives, and few negative effects or risks, are much more likely to be merged, and merged quickly.
Risky and less valuable changes are very unlikely to be merged, and may be rejected outright
rather than receive iterations of review.

#### Positives

- Fixes the root cause of a bug in existing functionality
- Adds functionality or fixes a problem needed by a large number of users
- Simple, targeted
- Easily tested; has tests
- Reduces complexity and lines of code
- Change has already been discussed and is known to committers

#### Negatives, risks

- Band-aids a symptom of a bug only
- Introduces complex new functionality, especially an API that needs to be supported
- Adds complexity that only helps a niche use case
- Changes a public API or semantics (rarely allowed)
- Adds large dependencies
- Changes versions of existing dependencies
- Adds a large amount of code
- Makes lots of modifications in one "big bang" change

## Contributing code changes

Please review the preceding section before proposing a code change. This section documents how to do so.

**When you contribute code, you affirm that the contribution is your original work and that you
license the work to the project under the project's open source license. Whether or not you state
this explicitly, by submitting any copyrighted material via pull request, email, or other means
you agree to license the material under the project's open source license and warrant that you
have the legal authority to do so.**

### Cloning the Apache HugeGraph<span class="tm">&trade;</span> source code

If you are interested in working with the newest under-development code or contributing to Apache HugeGraph development, you can check out the master branch from Git:

    # Master development branch
    git clone git@github.com:apache/incubator-hugegraph.git

Once you've downloaded HugeGraph, you can find instructions for installing and building it on the [documentation page](https://github.com/apache/incubator-hugegraph-doc/tree/master/content/en/docs)

### ISSUE

Generally, HugeGraph uses ISSUE to track logical issues, including bugs and improvements, and uses
GitHub pull requests to manage the review and merge of specific code changes. That is, ISSUEs are
used to describe _what_ should be fixed or changed, and high-level approaches, and pull requests
describe _how_ to implement that change in the project's source code. For example, major design
decisions are discussed in ISSUE.

1. Find the existing HugeGraph ISSUE that the change pertains to.
    1. Do not create a new ISSUE if creating a change to address an existing issue in ISSUE; add to
       the existing discussion and work instead
    1. Look for existing pull requests that are linked from the ISSUE, to understand if someone is
       already working on the ISSUE
1. If the change is new, then it usually needs a new ISSUE. However, trivial changes, where the
   what should change is virtually the same as the how it should change do not require a ISSUE.
   Example: `Fix typos in Foo scaladoc`
1. If required, create a new ISSUE:
    1. Provide a descriptive Title. "Update web UI" or "Problem in scheduler" is not sufficient.
       "Kafka Streaming support fails to handle empty queue in YARN cluster mode" is good.
    1. Write a detailed Description. For bug reports, this should ideally include a short
       reproduction of the problem. For new features, it may include a design document.
    1. Set required fields:
        1. **Issue Type**. Generally, Bug, Improvement and New Feature are the only types used in HugeGraph.
        1. **Priority**. Set to Major or below; higher priorities are generally reserved for
           committers to set. The main exception is correctness or data-loss issues, which can be flagged as
           Blockers. ISSUE tends to unfortunately conflate "size" and "importance" in its
           Priority field values. Their meaning is roughly:
            1. Blocker: pointless to release without this change as the release would be unusable
               to a large minority of users. Correctness and data loss issues should be considered Blockers for their target versions.
            1. Critical: a large minority of users are missing important functionality without
               this, and/or a workaround is difficult
            1. Major: a small minority of users are missing important functionality without this,
               and there is a workaround
            1. Minor: a niche use case is missing some support, but it does not affect usage or
               is easily worked around
            1. Trivial: a nice-to-have change but unlikely to be any problem in practice otherwise
        1. **Component**
        1. **Affects Version**. For Bugs, assign at least one version that is known to exhibit the
           problem or need the change
        1. **Label**. Not widely used, except for the following:
            - `correctness`: a correctness issue
            - `data-loss`: a data loss issue
            - `release-notes`: the change's effects need mention in release notes. The ISSUE or pull request
              should include detail suitable for inclusion in release notes -- see "Docs Text" below.
            - `starter`: small, simple change suitable for new contributors
        1. **Docs Text**: For issues that require an entry in the release notes, this should contain the
           information that the release manager should include in Release Notes. This should include a short summary
           of what behavior is impacted, and detail on what behavior changed. It can be provisionally filled out
           when the ISSUE is opened, but will likely need to be updated with final details when the issue is
           resolved.
    1. Do not set the following fields:
        1. **Fix Version**. This is assigned by committers only when resolved.
        1. **Target Version**. This is assigned by committers to indicate a PR has been accepted for
           possible fix by the target version.
    1. Do not include a patch file; pull requests are used to propose the actual change.
1. If the change is a large change, consider inviting discussion on the issue at
   `dev@hugegraph.org` first before proceeding to implement the change.

### Pull request

1. [Fork](https://help.github.com/articles/fork-a-repo/) the GitHub repository at
   [incubator-hugegraph](https://github.com/apache/incubator-hugegraph/) if you haven't already
1. Clone your fork, create a new branch, push commits to the branch.
1. Consider whether documentation or tests need to be added or updated as part of the change,
   and add them as needed.
    1. When you add tests, make sure the tests are self-descriptive.
    1. Also, you should consider writing a ISSUE ID in the tests when your pull request targets to fix
       a specific issue. In practice, usually it is added when a ISSUE type is a bug or a PR adds
       a couple of tests to an existing test class. See the examples below:
        - Scala
          ```
          test("HugeGraph-12345: a short description of the test") {
            ...
          ```
        - Java
          ```
          @Test
          public void testCase() {
            // HugeGraph-12345: a short description of the test
            ...
          ```

### The review process

- Other reviewers, including committers, may comment on the changes and suggest modifications.
  Changes can be added by simply pushing more commits to the same branch.
- Lively, polite, rapid technical debate is encouraged from everyone in the community. The outcome
  may be a rejection of the entire change.
- Keep in mind that changes to more critical parts of HugeGraph, like its core components, will
  be subjected to more review, and may require more testing and proof of its correctness than
  other changes.
- Reviewers can indicate that a change looks suitable for merging with a comment such as: "I think
  this patch looks good". HugeGraph uses the LGTM convention for indicating the strongest level of
  technical sign-off on a patch: simply comment with the word "LGTM". It specifically means: "I've
  looked at this thoroughly and take as much ownership as if I wrote the patch myself". If you
  comment LGTM you will be expected to help with bugs or follow-up issues on the patch. Consistent,
  judicious use of LGTMs is a great way to gain credibility as a reviewer with the broader community.
- Sometimes, other changes will be merged which conflict with your pull request's changes. The
  PR can't be merged until the conflict is resolved. This can be resolved by, for example, adding a remote
  to keep up with upstream changes by `git remote add upstream git@github.com:apache/incubator-hugegraph.git`,
  running `git fetch upstream` followed by `git rebase upstream/master` and resolving the conflicts by hand,
  then pushing the result to your branch.
- Try to be responsive to the discussion rather than let days pass between replies

### Closing your pull request / ISSUE

- If a change is accepted, it will be merged and the pull request will automatically be closed,
  along with the associated ISSUE if any
    - Note that in the rare case you are asked to open a pull request against a branch besides
      `master`, that you will actually have to close the pull request manually
    - The ISSUE will be Assigned to the primary contributor to the change as a way of giving credit.
      If the ISSUE isn't closed and/or Assigned promptly, comment on the ISSUE.
- If your pull request is ultimately rejected, please close it promptly
    - ... because committers can't close PRs directly
    - Pull requests will be automatically closed by an automated process at Apache after about a
      week if a committer has made a comment like "mind closing this PR?" This means that the
      committer is specifically requesting that it be closed.
- If a pull request has gotten little or no attention, consider improving the description or
  the change itself and ping likely reviewers again after a few days. Consider proposing a
  change that's easier to include, like a smaller and/or less invasive change.
- If it has been reviewed but not taken up after weeks, after soliciting review from the
  most relevant reviewers, or, has met with neutral reactions, the outcome may be considered a
  "soft no". It is helpful to withdraw and close the PR in this case.
- If a pull request is closed because it is deemed not the right approach to resolve a ISSUE,
  then leave the ISSUE open. However if the review makes it clear that the issue identified in
  the ISSUE is not going to be resolved by any pull request (not a problem, won't fix) then also
  resolve the ISSUE.

### If in doubt

If you're not sure about the right style for something, try to follow the style of the existing
codebase. Look at whether there are other examples in the code that use your feature. Feel free
to ask on the `dev@HugeGraph.apache.org` list as well and/or ask committers.

## Code of conduct
The Apache HugeGraph project follows the [Apache Software Foundation Code of Conduct](https://www.apache.org/foundation/policies/conduct.html). The [code of conduct](https://www.apache.org/foundation/policies/conduct.html) applies to all spaces managed by the Apache Software Foundation, including IRC, all public and private mailing lists, issue trackers, wikis, blogs, Twitter, and any other communication channel used by our communities. A code of conduct which is specific to in-person events (ie., conferences) is codified in the published ASF anti-harassment policy.

We expect this code of conduct to be honored by everyone who participates in the Apache community formally or informally, or claims any affiliation with the Foundation, in any Foundation-related activities and especially when representing the ASF, in any role.

This code <u>is not exhaustive or complete</u>. It serves to distill our common understanding of a collaborative, shared environment and goals. We expect it to be followed in spirit as much as in the letter, so that it can enrich all of us and the technical communities in which we participate.

For more information and specific guidelines, refer to the [Apache Software Foundation Code of Conduct](https://www.apache.org/foundation/policies/conduct.html) .
