CREATE TABLE profiles (
    id INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    name TEXT NOT NULL,
    url TEXT NOT NULL,
    is_open BOOLEAN NOT NULL,
    member_since TIMESTAMP WITH TIME ZONE NOT NULL,
    n_followers INTEGER,
    n_following INTEGER,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT current_timestamp,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT pk_profiles PRIMARY KEY (id),
    CONSTRAINT uq_profiles UNIQUE (url)
);

CREATE TABLE profile_followers (
    id INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    follower_id INTEGER NOT NULL,
    followee_id INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT current_timestamp,
    CONSTRAINT uq_profile_followers UNIQUE (follower_id, followee_id),
    CONSTRAINT fk_profile_followers_follower FOREIGN KEY (
        follower_id
    ) REFERENCES profiles (id) ON DELETE CASCADE,
    CONSTRAINT fk_profile_followers_followee FOREIGN KEY (
        followee_id
    ) REFERENCES profiles (id) ON DELETE CASCADE,
    CONSTRAINT pk_profile_followers PRIMARY KEY (id),
    CHECK (follower_id <> followee_id)
);

CREATE TABLE posts (
    id INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    profile_id INTEGER NOT NULL,
    url TEXT NOT NULL,
    content TEXT NOT NULL,
    uploaded_at TIMESTAMP WITH TIME ZONE NOT NULL,
    fake_score FLOAT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT current_timestamp,
    CONSTRAINT pk_posts PRIMARY KEY (id),
    CONSTRAINT uq_posts UNIQUE (url),
    CONSTRAINT fk_posts_profiles FOREIGN KEY (profile_id) REFERENCES profiles (
        id
    ) ON DELETE CASCADE
);

-- TODO maybe use MCP?
CREATE TABLE models (
    id INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    name TEXT NOT NULL,
    url TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT current_timestamp,
    CONSTRAINT pk_models PRIMARY KEY (id),
    CONSTRAINT uq_models UNIQUE (url),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE post_scores (
    id INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    post_id INTEGER NOT NULL,
    model_id INTEGER NOT NULL,
    score FLOAT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT current_timestamp,
    CONSTRAINT pk_post_scores PRIMARY KEY (id),
    CONSTRAINT fk_post_scores_posts FOREIGN KEY (post_id) REFERENCES posts (
        id
    ) ON DELETE CASCADE,
    CONSTRAINT fk_post_scores_models FOREIGN KEY (model_id) REFERENCES models (
        id
    ) ON DELETE CASCADE
);

CREATE TABLE pages (
    id INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    name TEXT NOT NULL,
    url TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT current_timestamp,
    CONSTRAINT pk_pages PRIMARY KEY (id),
    CONSTRAINT uq_pages UNIQUE (url)
);

CREATE TABLE page_followers (
    page_id INTEGER NOT NULL,
    profile_id INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT current_timestamp,
    CONSTRAINT fk_page_followers_pages FOREIGN KEY (page_id) REFERENCES pages (
        id
    ) ON DELETE CASCADE,
    CONSTRAINT fk_page_followers_profiles FOREIGN KEY (
        profile_id
    ) REFERENCES profiles (id) ON DELETE CASCADE,
    CONSTRAINT uq_page_followers UNIQUE (page_id, profile_id)
);

CREATE TABLE comments (
    id INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    profile_id_poster INTEGER NOT NULL,
    profile_id_commenter INTEGER NOT NULL,
    url TEXT NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT current_timestamp,
    CONSTRAINT pk_comments PRIMARY KEY (id),
    CONSTRAINT uq_comments UNIQUE (url),
    CONSTRAINT fk_comments_poster FOREIGN KEY (
        profile_id_poster
    ) REFERENCES profiles (id) ON DELETE CASCADE,
    CONSTRAINT fk_comments_commenter FOREIGN KEY (
        profile_id_commenter
    ) REFERENCES profiles (id) ON DELETE CASCADE
);
