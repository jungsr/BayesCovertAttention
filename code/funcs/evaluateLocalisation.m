
function PC = evaluateLocalisation(N, sigma, T, expec)

dPrior(1) = expec;						% prob of target in location 1
dPrior([2:N]) = (1-expec)/(N-1);		% prob of target elsewhere

xMu = eye(N);							% deterministic p(xmu|D)
correct = 0;							% initialse number of correct trials

for t=1:T
	
	%% STEP 1: GENERATIVE
	d = mnrnd(1,dPrior);				% sample display type
	x = normrnd(d,sigma);				% sample noisy observation
	
	%% step 2: INFERENCE, now we know x
	% The observer is calculating the joint probability of P(D,x,sigma,dprior)
	% It will do this by evaluating the joint probability over all N
	% categorical values of D (display type)
	for dparam=1:N
		% log likelihood of each value of D
		LLd(dparam) = sum( log( normpdf(x, xMu(dparam,:), sigma) ));
	end
	logPosteriorD = LLd + log(dPrior);	% posterior
	
	%% STEP 3: DECISION
	response = argmax(logPosteriorD);
	if response == argmax(d)
		correct = correct + 1;
	end
end
PC = correct/T;

return