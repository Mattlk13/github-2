-- |
-- The actions API as documented at
-- <https://docs.github.com/en/rest/reference/actions>.

module GitHub.Endpoints.Actions.Cache (
    cacheUsageOrganizationR,
    cacheUsageByRepositoryR,
    cacheUsageR,
    cachesForRepoR,
    deleteCacheR,
    module GitHub.Data
    ) where

import GitHub.Data
import GitHub.Internal.Prelude
import Prelude ()

-- | Get Actions cache usage for the organization.
-- See <https://docs.github.com/en/rest/actions/cache#get-github-actions-cache-usage-for-an-organization>
cacheUsageOrganizationR
    :: Name Organization
    -> GenRequest 'MtJSON 'RA OrganizationCacheUsage
cacheUsageOrganizationR org =
    Query ["orgs", toPathPart org, "actions", "cache", "usage"] []

-- | List repositories with GitHub Actions cache usage for an organization.
-- See <https://docs.github.com/en/rest/actions/cache#list-repositories-with-github-actions-cache-usage-for-an-organization>
cacheUsageByRepositoryR
    :: Name Organization
    -> FetchCount
    -> GenRequest 'MtJSON 'RA (WithTotalCount RepositoryCacheUsage)
cacheUsageByRepositoryR org =
    PagedQuery ["orgs", toPathPart org, "actions", "cache", "usage-by-repository"] []

-- | Get GitHub Actions cache usage for a repository.
-- See <https://docs.github.com/en/rest/actions/cache#get-github-actions-cache-usage-for-a-repository>
cacheUsageR
    :: Name Owner
    -> Name Repo
    -> Request k RepositoryCacheUsage
cacheUsageR user repo =
    Query ["repos", toPathPart user, toPathPart repo, "actions", "cache", "usage"] []

-- | List the GitHub Actions caches for a repository.
-- See <https://docs.github.com/en/rest/actions/cache#list-github-actions-caches-for-a-repository>
cachesForRepoR
    :: Name Owner
    -> Name Repo
    -> CacheMod
    -> FetchCount
    -> GenRequest 'MtJSON 'RA (WithTotalCount Cache)
cachesForRepoR user repo opts = PagedQuery
    ["repos", toPathPart user, toPathPart repo, "actions", "caches"]
    (cacheModToQueryString opts)

-- | Delete GitHub Actions cache for a repository.
-- See <https://docs.github.com/en/rest/actions/cache#delete-a-github-actions-cache-for-a-repository-using-a-cache-id>
deleteCacheR
    :: Name Owner
    -> Name Repo
    -> Id Cache
    -> GenRequest 'MtUnit 'RW ()
deleteCacheR user repo cacheid =
    Command Delete parts mempty
  where
    parts = ["repos", toPathPart user, toPathPart repo, "actions", "caches", toPathPart cacheid]
