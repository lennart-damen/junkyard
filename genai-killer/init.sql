-- TODO add foreign keys
CREATE TABLE profiles (
    id INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    name TEXT NOT NULL,
    url TEXT NOT NULL,
    is_open BOOLEAN NOT NULL,
    member_since TIMESTAMP WITH TIME ZONE NOT NULL,
    n_followers INTEGER,
    n_following INTEGER,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT current_timestamp,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE followers (
    id SERIAL PRIMARY KEY,
    follower_id INTEGER NOT NULL,
    followee_id INTEGER NOT NULL,
    followed_at TIMESTAMP DEFAULT current_timestamp,
    UNIQUE (follower_id, followee_id),
    FOREIGN KEY (follower_id) REFERENCES profiles (id) ON DELETE CASCADE,
    FOREIGN KEY (followee_id) REFERENCES profiles (id) ON DELETE CASCADE,
    CHECK (follower_id <> followee_id)
);

CREATE TABLE posts (
    id INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    profile_id INTEGER NOT NULL,
    url TEXT NOT NULL,
    content TEXT NOT NULL,
    uploaded_at TIMESTAMP WITH TIME ZONE NOT NULL,
    fake_score FLOAT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT current_timestamp
);

CREATE TABLE models (
    id INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    name TEXT NOT NULL,
    url TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT current_timestamp,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE post_scores (
    id INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    post_id INTEGER NOT NULL,
    model_id INTEGER NOT NULL,
    score FLOAT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT current_timestamp
);

CREATE TYPE activity_type AS ENUM (
    'COMMENT',
    'LIKE'
);

CREATE TABLE activities (
    id INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    profile_id INTEGER NOT NULL,
    url TEXT NOT NULL,
    type killer.ACTIVITY_TYPE,
    performed_on INTEGER,  -- fk with posts
    content TEXT,
    performed_at TIMESTAMP WITH TIME ZONE NOT NULL,
    fake_score FLOAT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT current_timestamp
);
